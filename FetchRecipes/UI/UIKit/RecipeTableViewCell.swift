//
//  RecipeTableViewCell.swift
//  FetchRecipes
//
//  Created by Todd Mathison on 11/7/24.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "RecipeTableViewCell"
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCuisine: UILabel!
    @IBOutlet weak var imgRecipe: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
