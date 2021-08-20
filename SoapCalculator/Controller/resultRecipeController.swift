import UIKit
import RealmSwift

class resultRecipeController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var superfattingTextView: UILabel!
    @IBOutlet weak var fragranceTextView: UILabel!
    @IBOutlet weak var waterTextView: UILabel!
    @IBOutlet weak var lyeTypeTextView: UILabel!
    @IBOutlet weak var lyeOrKohWeight: UILabel!
    @IBOutlet weak var totalWeightTextView: UILabel!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var oilTableView: UITableView!
    @IBOutlet weak var saveRecipeButton: UIButton!
    
    var soap: Soap!
    var isFromWater: Bool!
    var unit: String!
    var oilNames: [String]!
    var oilAmounts: [Double]!
    var realm : Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oilTableView.delegate = self
        oilTableView.dataSource = self
        
        realm = try! Realm()
        
        unit = soap.unit
        oilNames = soap.oilNames
        oilAmounts = soap.oilWeights
        
        if !isFromWater {
            saveRecipeButton.isHidden = true
            for i in 0..<soap.oilNamesList.count {
                oilNames.append(soap.oilNamesList[i])
                oilAmounts.append(soap.oilWeightsList[i])
            }
        }
        
        recipeLabel.text = soap.name
        imageView.image = UIImage(named: (soap.isLiquid ? "lSoap" : "soap"))
        superfattingTextView.text = soap.superfatting!.isEmpty ? "None" : "\(soap.superfatting!)%"
        fragranceTextView.text = soap.fragrance
        lyeTypeTextView.text = soap.isLiquid ? "Potassium Hydroxide (KOH):" : "Sodium Hydroxide (NaOH):"
        lyeOrKohWeight.text = "\(String(format: "%.2f", soap.lyeOrKWeight)) \(unit!)"
        waterTextView.text = "\(String(format: "%.2f", soap.waterWeight)) \(unit!)"
        totalWeightTextView.text = "\(String(format: "%.2f", soap.totalWeight)) \(unit!)"
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveRecipePressed(_ sender: Any) {
        postRecipe()
        self.performSegue(withIdentifier: "exitRecipe", sender: self)
    }
    
    func postRecipe() {
        for name in soap.oilNames {
            soap.oilNamesList.append(name)
        }
        for weight in soap.oilWeights {
            soap.oilWeightsList.append(weight)
        }
        try! realm.write{
            realm.add(soap)
        }
    }
}

extension resultRecipeController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oilNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = oilTableView.dequeueReusableCell(withIdentifier: "recipeOilCell") as! RecipeOilCell
        let oilName = oilNames[indexPath.row]
        let oilAmount = oilAmounts[indexPath.row]
        cell.oilNameLabel.text = oilName
        cell.oilWeight.text = "\(oilAmount) \(unit!)"
        
        return cell
    }
    
}
