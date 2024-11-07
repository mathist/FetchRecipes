import UIKit

class ViewController: UIViewController {

    let recipesPath: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            if let url = URL(string: recipesPath) {
                do {
                    if let recipeData = try await recipeData(url: url) {
                        if let recipes = try parseRecipeData(recipeData: recipeData) {
                            print(recipes)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

    func recipeData(url: URL) async throws -> Data? {
        var recipeData: Data?
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            recipeData = data
        } catch {
            throw error
        }
        return recipeData
    }
    

    func parseRecipeData(recipeData: Data) throws -> [Recipe]? {
        let decoder = JSONDecoder()
        do {
            let recipeData = try decoder.decode(RecipeData.self, from: recipeData)
            return recipeData.recipes
        } catch {
            throw error
        }
    }
    
}

