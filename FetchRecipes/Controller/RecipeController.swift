import Foundation
import UIKit

class RecipeController {
    
    static let shared = RecipeController()
    let recipesPath: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    var recipes: [Recipe] = []
    
    init() {
    }
    
    func fetchRecipes() async {
        if let url = URL(string: recipesPath) {
            do {
                if let recipeData = try await recipeData(url: url) {
                    if let recipes = try parseRecipeData(recipeData: recipeData) {
                        self.recipes = recipes
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func cancelURLSessiontasks() {
       URLSession.shared.getAllTasks { tasks in
           tasks.forEach({$0.cancel()})
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
    
    func image(url: URL) async throws -> UIImage? {
        var uiImage: UIImage?
        
          do {
            if let cachedImage = ImageCache.shared.getImage(url: url) {
              uiImage = cachedImage
            } else {
              let (data, _) = try await URLSession.shared.data(from: url)
              if let image = UIImage(data: data) {
                uiImage = image
                ImageCache.shared.setImage(url: url, image: image)
              }
            }
          } catch {
              throw error
          }
        
        return uiImage
    }
}
