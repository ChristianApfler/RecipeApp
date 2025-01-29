import SwiftUI

struct ContentView: View {
    @State private var recipes: [(id: String, recipe: Recipe)] = []  // Update to an array of tuples
    @State private var errorMessage: String? = nil
    @State private var showAddRecipeView = false // Track whether to show the Add Recipe view

    var body: some View {
        NavigationView {
            ZStack {
                // Full-screen background color
                Color.green.opacity(0.2)
                    .edgesIgnoringSafeArea(.all) // Ensure it covers the entire screen

                VStack {
                    ScrollView {
                        VStack(alignment: .center, spacing: 20) {
                            // Title for the app
                            Text("Recipe App")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .padding(.horizontal)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)

                            // Display the list of recipes
                            if !recipes.isEmpty {
                                VStack(alignment: .center) {
                                    ForEach(recipes, id: \.id) { (id, recipe) in
                                        NavigationLink(destination: RecipeDetailView(recipe: recipe, recipeID: id)) {
                                            Text(recipe.title)
                                                .font(.headline)
                                                .padding()
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.white.opacity(0.9))
                                                )
                                                .padding(.horizontal)
                                                .padding(.top, 5)
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            } else if let errorMessage = errorMessage {
                               
                                Text("Error: \(errorMessage)")
                                    .foregroundColor(.red)
                                    .padding()
                            } else {
                               
                                Text("Loading recipes...")
                                    .padding()
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }

                    VStack {
                        Spacer()
                        NavigationLink(destination: AddRecipeView()) {
                            Text("Add Recipe")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.bottom, 20)
                        }
                    }
                }
                .onAppear {
                    fetchRecipes()
                }
                .navigationBarHidden(true)
            }
        }
    }

    private func fetchRecipes() {
        Networking.shared.fetchData(path: "recipes") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRecipes):
                    self.recipes = fetchedRecipes 
                    print("Decoded Recipes: \(fetchedRecipes)")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
