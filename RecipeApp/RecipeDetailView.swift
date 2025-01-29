import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    let recipeID: String
    @Environment(\.presentationMode) var presentationMode // Used to dismiss the view after deletion

    var body: some View {
        ZStack {
          
            Color.green.opacity(0.2)
                .edgesIgnoringSafeArea(.all) // Ensure it covers the entire screen

            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {  // Align to the left
                        // Title of the recipe
                        Text(recipe.title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                            .padding(.top)

                        // Ingredients Section
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .padding(.top, 20)

                        // Display each ingredient
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            Text("- \(ingredient)")
                                .font(.body)
                                .padding(.leading)
                                .padding(.bottom, 2)
                        }

                        // Instructions Section
                        Text("Instructions")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .padding(.top, 20)

                        // Display each instruction
                        ForEach(recipe.instructions, id: \.self) { instruction in
                            Text(instruction)
                                .font(.body)
                                .padding(.leading)
                                .padding(.bottom, 5)
                        }

                        Spacer() //Pushes Button to the buttom
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Floating Delete Button at the bottom
                Button(action: {
                    Networking.shared.deleteRecipe(path: "recipes/\(recipeID)") { result in
                        switch result {
                        case .success:
                            print("Recipe deleted successfully!")
                            DispatchQueue.main.async {
                                self.presentationMode.wrappedValue.dismiss() // Dismiss the view
                            }
                        case .failure(let error):
                            print("Failed to delete recipe: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Delete Recipe")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
