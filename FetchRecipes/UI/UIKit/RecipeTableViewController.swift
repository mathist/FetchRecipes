import UIKit

class RecipeTableViewController: UITableViewController {
    
    @IBOutlet weak var lblError: UILabel!
    var currentPath: String = RecipeController.recipesPath
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        Task {
            await self.loadRecipes(path: self.currentPath)
        }
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        Task {
            await self.loadRecipes(path: self.currentPath)
            self.refreshControl?.endRefreshing()
            print("Refresh Complete")
        }
    }
    
    func loadRecipes(path: String) async {
        let result = await RecipeController.shared.fetchRecipes(recipePath: path)
        
        switch result {
        case .success(_):
            lblError.text = nil
            lblError.isHidden = true
        case .failure(let error):
            lblError.text = error.localizedDescription
            lblError.isHidden = false
        }
        
        self.tableView.reloadData()
        let height: CGFloat = lblError.isHidden ? 52 : 100.0
        self.tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: lblError.frame.size.width, height: height)
    }
    
    @IBAction func changeRecipeData(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 1:
            currentPath = RecipeController.emptyRecipePath
        case 2:
            currentPath = RecipeController.malformedRecipePath
        default:
            currentPath = RecipeController.recipesPath
        }
        
        Task {
            await self.loadRecipes(path: self.currentPath)
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
