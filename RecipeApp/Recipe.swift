import Foundation


struct Recipe: Decodable, Encodable {
    var ingredients: [String]
    var instructions: [String]
    var title: String
    
    
    private enum RootCodingKeys: String, CodingKey {
        case ingredients
        case instructions
        case title
    }
    
    // Standard initializer for creating new recipes
    init(title: String, ingredients: [String], instructions: [String]) {
        self.title = title
        self.ingredients = ingredients
        self.instructions = instructions
    }
    
    // Custom decoding for Firebase response (if needed)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        self.ingredients = try container.decode([String].self, forKey: .ingredients)
        self.instructions = try container.decode([String].self, forKey: .instructions)
        self.title = try container.decode(String.self, forKey: .title)
    }
}


// A struct to represent the root structure of Firebase response
struct RecipesContainer: Decodable {
    var recipes: [String: Recipe]
    
    private enum CodingKeys: String, CodingKey {
        case recipes = ""  // Empty string because we are expecting the recipes to be inside the root object
    }
}
