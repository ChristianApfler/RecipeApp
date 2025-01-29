/*import SwiftUI

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    func fetchRecipes() {
        Networking.shared.fetchData(path: "recipes") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    self.recipes = json.map { $0.recipe } 
                case .failure(let error):
                    print("Failed to fetch recipes: \(error.localizedDescription)")
                }
            }
        }
    }
}*/
