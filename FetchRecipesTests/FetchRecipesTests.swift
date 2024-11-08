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

    func testParseGoodData() {
        do {
            if let recipes = try RecipeController().parseRecipeData(recipeData: goodData()) {
                XCTAssertTrue(recipes.count > 0)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testParseEmptyData() {
        do {
            if let recipes = try RecipeController().parseRecipeData(recipeData: emptyData()) {
                XCTAssertTrue(recipes.count == 0)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testMalformedData() {
        do {
            if let _ = try RecipeController().parseRecipeData(recipeData: malformedData()) {
                XCTFail("This should not parse")
            }
        } catch {
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
        }
    }
    
    func testMalformedRecipes() async {
        let result = await RecipeController().fetchRecipes(recipePath: RecipeController.malformedRecipePath)
        
        switch result {
        case .success(_):
            XCTFail("Recipes were found")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
        }
    }
        
    func testNoRecipes() async {
        let result = await RecipeController().fetchRecipes(recipePath: RecipeController.emptyRecipePath)
        
        switch result {
        case .success(_):
            XCTFail("Recipes were found")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "No recipes found")
        }
    }

    func testRecipes() async {
        let result = await RecipeController().fetchRecipes(recipePath: RecipeController.recipesPath)
        
        switch result {
        case .success(let recipes):
            XCTAssertTrue(recipes.count > 0)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func goodData() -> Data {
        
        let jsonString = """
        { 
            "recipes" : 
            [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                },
                {
                    "cuisine": "British",
                    "name": "Apple & Blackberry Crumble",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                    "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                },
                {
                    "cuisine": "British",
                    "name": "Apple Frangipan Tart",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg",
                    "uuid": "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
                    "youtube_url": "https://www.youtube.com/watch?v=rp8Slv4INLk"
                }
            ]
        }
        """

        return Data(jsonString.utf8)
    }
    
    func emptyData() -> Data {
        
        let jsonString = """
        { 
            "recipes" : 
            [
            ]
        }
        """

        return Data(jsonString.utf8)
    }
    
    //  Missing "Name" field in one of the recipes
    func malformedData() -> Data {
            
        let jsonString = """
        { 
            "recipes" : 
            [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                },
                {
                    "cuisine": "British",
                    "name": "Apple & Blackberry Crumble",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                    "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                },
                {
                    "cuisine": "British",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg",
                    "uuid": "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
                    "youtube_url": "https://www.youtube.com/watch?v=rp8Slv4INLk"
                }
            ]
        }
        """

        return Data(jsonString.utf8)
    }
    
}
