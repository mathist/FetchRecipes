import SwiftUI

struct ContentView: View {
    
    @ObservedObject var recipeController: RecipeController
    
    init() {
        self.recipeController = RecipeController(path: RecipeController.recipesPath)
    }
    
    var body: some View {        
        VStack(spacing: 4) {
            ScrollViewReader() { proxy in
                ScrollView() {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(recipeController.recipes.indices, id: \.self) { index in
                            let recipe = recipeController.recipes[index]
                            
                            HStack(alignment: .top, spacing: 4) {
                                DisplayImageFromNetwork(imageUrl: URL(string: recipe.photo_url_small)!)
                                    .frame(width: 100, height: 100)

                                VStack(alignment: .leading) {
                                    Text(recipe.name)
                                    Text(recipe.cuisine)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
}
