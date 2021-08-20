import UIKit

class OilWeightCustomCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var oilLabel: UILabel!
    @IBOutlet weak var weightTextfield: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
