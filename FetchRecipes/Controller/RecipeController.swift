import Foundation
import UIKit

class RecipeController: ObservableObject {
    
    static let shared = RecipeController()
    static let recipesPath: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    static let malformedRecipePath: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    static let emptyRecipePath: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    @Published var recipes = [Recipe]()
    
    var badURLError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL not valid"]) as Error
    var jsonError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON not valid"]) as Error
    var noRecipesError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No recipes found"]) as Error

    init(path: String? = nil) {
        
        if let path = path {
            Task {
                await self.fetchRecipes(recipePath: path)
            }
        }
    }
    
    @MainActor
    func fetchRecipes(recipePath: String) async -> Result<[Recipe], Error> {
        if let url = URL(string: recipePath) {
            do {
                let recipeData = try await recipeData(url: url)
                if let recipes = try parseRecipeData(recipeData: recipeData) {
                    self.recipes = recipes
                    if !recipes.isEmpty {
                        return .success(self.recipes)
                    } else {
                        return .failure(noRecipesError)
                    }
                } else {
                    return .failure(jsonError)
                }
            } catch {
                return .failure(error)
            }
        } else {
            return .failure(badURLError)
        }
    }
    
    func cancelURLSessiontasks() {
       URLSession.shared.getAllTasks { tasks in
           tasks.forEach({$0.cancel()})
       }
     }
    
    func recipeData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
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
    
    func image(url: URL) async throws -> UIImage? {
        do {
            if let cachedImage = ImageCache.shared.getImage(url: url) {
                return cachedImage
            } else {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    ImageCache.shared.setImage(url: url, image: image)
                    return image
                } else {
                    return nil
                }
            }
        } catch {
            throw error
        }
    }
}
