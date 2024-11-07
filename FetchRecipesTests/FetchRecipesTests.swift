//
//  FetchRecipesTests.swift
//  FetchRecipesTests
//
//  Created by Todd Mathison on 11/7/24.
//

import Testing
import XCTest
@testable import FetchRecipes

final class FetchRecipesTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMalformedRecipes() async {
        let result = await RecipeController.shared.fetchRecipes(recipePath: RecipeController.malformedRecipePath)
        
        switch result {
        case .success(_):
            XCTFail("Recipes were found")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
        }
    }
        
    func testNoRecipes() async {
        let result = await RecipeController.shared.fetchRecipes(recipePath: RecipeController.emptyRecipePath)
        
        switch result {
        case .success(_):
            XCTFail("Recipes were found")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "No recipes found")
        }
    }

    func testRecipes() async {
        let result = await RecipeController.shared.fetchRecipes(recipePath: RecipeController.recipesPath)
        
        switch result {
        case .success(let recipes):
            XCTAssertTrue(recipes.count > 0)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

}
