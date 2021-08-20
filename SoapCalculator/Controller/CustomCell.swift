import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var soapView: UIView!
    @IBOutlet weak var typeImg: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var soap: Soap!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
