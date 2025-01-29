import Foundation

class Networking {
    
    static let shared = Networking()
    
    let baseURL = "https://recipedatabase-eb21b-default-rtdb.europe-west1.firebasedatabase.app/"
    
    // Fetch data from Firebase Realtime Database (returns a Result type)
    func fetchData(path: String, completion: @escaping (Result<[(id: String, recipe: Recipe)], NetworkingError>) -> Void) {
        guard let url = URL(string: baseURL + "\(path).json") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for network issues
            if let error = error {
                completion(.failure(.networkOffline))
                return
            }
            
            // Check if the response is valid
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // Check if data is received
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Try to decode the data into a dictionary of recipes
            do {
                
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([String: Recipe].self, from: data)
                
                // Convert the dictionary to an array of tuples [(id, recipe)]
                let recipesWithIDs = decodedData.map { (id: $0.key, recipe: $0.value) }
                
                // Return the successfully decoded data with IDs
                completion(.success(recipesWithIDs))
            } catch {
                completion(.failure(.jsonSerializationError(error)))  
            }
        }
        
        task.resume()
    }

    func addRecipe(path: String, recipe: Recipe, completion: @escaping (Result<Void, NetworkingError>) -> Void) {
            // Create the URL for the POST request
            guard let url = URL(string: baseURL + "\(path).json") else {
                completion(.failure(.invalidURL))  // Return invalid URL error
                return
            }

            // Prepare the recipe data as a dictionary
            let recipeData: [String: Any] = [
                "title": recipe.title,
                "ingredients": recipe.ingredients,
                "instructions": recipe.instructions
            ]
            
            // Create a URLRequest for the POST request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Convert the recipe data into JSON
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: recipeData, options: [])
                request.httpBody = jsonData
                
                // Perform the POST request
                let task = URLSession.shared.dataTask(with: request) { _, response, error in
                    if let error = error {
                        completion(.failure(.networkOffline))  // Return network offline error
                        return
                    }
                    
                    // Check the response status code
                    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                        completion(.failure(.invalidResponse))  // Return invalid response error
                        return
                    }
                    
                    // If the request was successful
                    completion(.success(()))
                }
                
                task.resume()
            } catch {
                completion(.failure(.jsonSerializationError(error)))  // Return JSON serialization error
            }
        }
    
    func deleteRecipe(path: String, completion: @escaping (Result<Void, NetworkingError>) -> Void) {
        guard let url = URL(string: baseURL + "\(path).json") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE" // Firebase uses DELETE method to remove data
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(.networkOffline))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            completion(.success(()))
        }
        
        task.resume()
    }
}
