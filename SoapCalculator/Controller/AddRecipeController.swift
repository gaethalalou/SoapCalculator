import UIKit
import RealmSwift

class AddRecipeController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var liquidButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var tagTextfield: UITextField!
    
    let greenColor = UIColor(red: CGFloat(129.0/255.0), green: CGFloat(178.0/255.0), blue: CGFloat(154.0/255.0), alpha: CGFloat(1.0))
    let indepColor = UIColor(red: CGFloat(61.0/255.0), green: CGFloat(64.0/255.0), blue: CGFloat(91.0/255.0), alpha: CGFloat(1.0))
    let date = Date.getCurrentDate("MM/dd/yyyy")
    
    var realm: Realm!
    var soap: Soap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        titleTextfield.delegate = self
        tagTextfield.delegate = self
        realm = try! Realm()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func barButtonPressed(_ sender: Any) {
        selectButton(barButton, liquidButton)
    }
    
    @IBAction func liquidButtonPressed(_ sender: Any) {
        selectButton(liquidButton, barButton)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToOil", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToOil") {
            let vc = segue.destination as! OilController
            soap = Soap(name: titleTextfield.text!, isLiquid: liquidButton.isSelected, date: date, tag: tagTextfield.text!)
            vc.soap = soap
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        checkField()
    }
    
    func checkField() {
        if titleTextfield.text!.isEmpty || tagTextfield.text!.isEmpty {
            addButton.isEnabled = false
            addButton.backgroundColor = .systemGray
        }
        else{
            addButton.isEnabled = true
            addButton.backgroundColor = greenColor
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddRecipeController {
    func selectButton(_ firstButton: UIButton, _ secondButton: UIButton){
        firstButton.isSelected = true
        secondButton.isSelected = false
        firstButton.backgroundColor = indepColor
        secondButton.backgroundColor = .clear
    }
}

extension Date {
    static func getCurrentDate(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
}
