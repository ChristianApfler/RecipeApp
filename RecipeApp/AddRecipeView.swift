import SwiftUI

struct AddRecipeView: View {
    @Environment(\.presentationMode) var presentationMode // Used to dismiss the view
    @State private var title: String = ""
    @State private var ingredients: String = ""
    @State private var instructions: [String] = [""]
    
    var body: some View {
        ZStack {
           
            Color.green.opacity(0.2)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
              
                Text("Add New Recipe")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .padding(.top, 40)

                
                TextField("Recipe Title", text: $title)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .padding(.horizontal)

             
                TextField("Ingredients (comma separated)", text: $ingredients)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .padding(.horizontal)

                
                Text("Instructions")
                    .font(.headline)
                    .padding(.top, 10)

                // Dynamic instruction fields
                ForEach(0..<instructions.count, id: \.self) { index in
                    TextField("Instruction \(index + 1)", text: $instructions[index])
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .padding(.horizontal)
                }

                // Button to add new instruction
                Button(action: {
                    instructions.append("") // Add a new empty instruction field
                }) {
                    Text("Add Instruction")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)

                // Add Recipe Button
                Button(action: {
                    // Validate inputs
                    guard !title.isEmpty, !ingredients.isEmpty, !instructions.isEmpty else {
                        print("Please fill out all fields")
                        return
                    }

                    // Convert ingredients into an array from comma-separated string
                    let ingredientsArray = ingredients.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                    
                    // Create a new recipe object
                    let newRecipe = Recipe(title: title, ingredients: ingredientsArray, instructions: instructions)
                    
                    // Add the recipe to Firebase
                    Networking.shared.addRecipe(path: "recipes", recipe: newRecipe) { result in
                        switch result {
                        case .success:
                            print("Recipe added successfully!")
                            DispatchQueue.main.async {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        case .failure(let error):
                            print("Failed to add recipe: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Add Recipe")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top) 
        }
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
