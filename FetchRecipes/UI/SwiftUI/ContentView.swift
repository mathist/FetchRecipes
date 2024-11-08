import SwiftUI

struct ContentView: View {
    
    @ObservedObject var recipeController: RecipeController
    @State var recipePath: String = RecipeController.recipesPath
    @State var errorMessage: String? = nil
    
    init() {
        self.recipeController = RecipeController(path: RecipeController.recipesPath)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Picker("", selection: $recipePath) {
                Text("Recipes").tag(RecipeController.recipesPath)
                Text("Empty").tag(RecipeController.emptyRecipePath)
                Text("Bad Data").tag(RecipeController.malformedRecipePath)
            }
            .pickerStyle(.segmented)
            .onChange(of: recipePath) {
                
                Task {
                    let result = await recipeController.fetchRecipes(recipePath: recipePath)
                    
                    switch result {
                    case .success(_):
                        errorMessage = nil
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
            }
                      
            ScrollViewReader() { proxy in
                ScrollView() {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(recipeController.recipes.indices, id: \.self) { index in
                            let recipe = recipeController.recipes[index]
                            
                            HStack(alignment: .top, spacing: 8) {
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
        .padding(8)
    }
}
