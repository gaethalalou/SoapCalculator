import UIKit

class RecipeOilCell: UITableViewCell {
    @IBOutlet weak var oilNameLabel: UILabel!
    @IBOutlet weak var oilWeight: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
