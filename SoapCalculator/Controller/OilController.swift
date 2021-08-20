import UIKit
import RealmSwift

class OilController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var oilTableView: UITableView!
    @IBOutlet weak var superfattingTextView: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    let cellColor = UIColor(red: CGFloat(242.0/255.0), green: CGFloat(204.0/255.0), blue: CGFloat(143.0/255.0), alpha: CGFloat(0.46))
    let indepColor = UIColor(red: CGFloat(61.0/255.0), green: CGFloat(64.0/255.0), blue: CGFloat(91.0/255.0), alpha: CGFloat(1.0))
    let eggshellColor = UIColor(red: CGFloat(244.0/255.0), green: CGFloat(241.0/255.0), blue: CGFloat(222.0/255.0), alpha: CGFloat(1.0))
    let greenColor = UIColor(red: CGFloat(129.0/255.0), green: CGFloat(178.0/255.0), blue: CGFloat(154.0/255.0), alpha: CGFloat(1.0))
    
    var oilList : [String]!
    var selectedOils : [String]!
    var soap : Soap!
    var tableIsSelected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        oilTableView.delegate = self
        oilTableView.dataSource = self
        superfattingTextView.delegate = self
        let realm = try! Realm()
        //        print(Realm.Configuration.defaultConfiguration.fileURL)
        oilList = Array(realm.objects(Oil.self)).map{$0.name!}
        selectedOils = []
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if oilTableView.indexPathsForSelectedRows != nil {
            for oil in oilTableView.indexPathsForSelectedRows! {
                selectedOils.append(String(oilList[oil[1]]))
            }
        }
        self.performSegue(withIdentifier: "goToWeight", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToWeight") {
            let vc = segue.destination as! OilWeightController
            soap.oilNames = selectedOils
            soap.superfatting = superfattingTextView.text
            vc.soap = soap
            selectedOils = []
        }
    }
}

extension OilController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oilList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "selectOilCell")
        cell.contentView.backgroundColor = cellColor
        cell.textLabel?.textColor = indepColor
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = oilList[indexPath.row]
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        checkField()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkField()
    }
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        checkField()
    }
    
    func checkField() {
        if superfattingTextView.text!.isEmpty || oilTableView.indexPathsForSelectedRows == nil {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .systemGray
        }
        else{
            nextButton.isEnabled = true
            nextButton.backgroundColor = greenColor
        }
    }
}
