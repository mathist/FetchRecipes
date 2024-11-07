//
//  RecipeTableViewController.swift
//  FetchRecipes
//
//  Created by Todd Mathison on 11/7/24.
//

import UIKit

class RecipeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await RecipeController.shared.fetchRecipes()
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeController.shared.recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.reuseIdentifier, for: indexPath) as! RecipeTableViewCell

        cell.lblName.text = RecipeController.shared.recipes[indexPath.row].name
        cell.lblCuisine.text = RecipeController.shared.recipes[indexPath.row].cuisine
        cell.imgRecipe.image = UIImage(systemName: "photo")
        
        Task {
            if let url = URL(string: RecipeController.shared.recipes[indexPath.row].photo_url_small) {
                
                do {
                    let image = try await RecipeController.shared.image(url: url)
                    cell.imgRecipe.image = image
                } catch {
                    
                }
            }
        }

        return cell
    }

}
