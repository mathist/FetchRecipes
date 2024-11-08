import SwiftUI

struct ContentView: View {
    
    @ObservedObject var recipeController: RecipeController
    @State var recipeType: Int = 0
    @State var errorMessage: String? = nil
    
    init() {
        self.recipeController = RecipeController(path: RecipeController.recipesPath)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Picker("", selection: $recipeType) {
                Text("Recipes").tag(0)
                Text("Empty").tag(1)
                Text("Bad Data").tag(2)
            }
            .pickerStyle(.segmented)
            .onChange(of: recipeType) {
                
                var path: String = ""
                
                if recipeType == 0 {path = RecipeController.recipesPath}
                if recipeType == 1 {path = RecipeController.emptyRecipePath}
                if recipeType == 2 {path = RecipeController.malformedRecipePath}

                Task {
                    let result = await recipeController.fetchRecipes(recipePath: path)
                    
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
