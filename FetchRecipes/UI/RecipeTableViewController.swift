import UIKit

class RecipeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        Task {
            await self.loadRecipes()
        }
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        Task {
            await self.loadRecipes()
            self.refreshControl?.endRefreshing()
            print("Refresh Complete")
        }
    }
    
    func loadRecipes() async {
        let result = await RecipeController.shared.fetchRecipes(recipePath: RecipeController.recipesPath)
        
        switch result {
        case .success(_):
            self.tableView.reloadData()
        case .failure(let error):
            print(error)
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
