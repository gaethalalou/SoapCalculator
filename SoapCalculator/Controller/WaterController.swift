import UIKit
import RealmSwift

class WaterController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var methodUnit: UILabel!
    @IBOutlet weak var waterPTextView: UITextField!
    @IBOutlet weak var fragranceTextView: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    
    let greenColor = UIColor(red: CGFloat(129.0/255.0), green: CGFloat(178.0/255.0), blue: CGFloat(154.0/255.0), alpha: CGFloat(1.0))
    
    
    var methods : [[String]] = [
        ["Lye Concentration", "%"],
        ["Water : Lye Ratio", ": 1"],
        ["Perecentage of Oils", "%"]
    ]
    
    var selectedMethod : String!
    var soap : Soap!
    var realm : Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        pickerView.delegate = self
        pickerView.dataSource = self
        waterPTextView.delegate = self
        selectedMethod = methods[1][0]
        realm = try! Realm()
        
        pickerView.selectRow(1, inComponent: 0, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        try! realm.write{
            realm.add(soap)
        }
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func calculateButtonPressed(_ sender: Any) {
        soap.waterP = Double(waterPTextView.text!)!
        calculateWater()
        self.performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToResult") {
            let vc = segue.destination as! resultRecipeController
            soap.fragrance = fragranceTextView.text!.isEmpty ? "None": fragranceTextView.text!
            soap.waterMethod = selectedMethod
            vc.isFromWater = true
            vc.soap = soap
        }
    }
    
    func calculateWater(){
        var lye : Double = 0.0
        var water : Double = 0.0
        var oilsArr : [Oil]!
        let oilWeights = soap.oilWeights
        
        for i in 0..<soap.oilNames.count {
            oilsArr = Array(realm.objects(Oil.self)).filter{$0.name == "\(soap.oilNames[0])"}
            lye += oilWeights[i] * (soap.isLiquid ? oilsArr[0].koh : oilsArr[0].lye)
        }
        
        soap.lyeOrKWeight = lye
        
        if selectedMethod == "Lye Concentration" {
            water = Double(lye)/Double(soap.waterP/100) - Double(lye)
        } else if selectedMethod == "Water : Lye Ratio" {
            water = Double(soap.waterP)*Double(lye)
        } else if selectedMethod == "Perecentage of Oils" {
            water = Double(soap.totalOilWeight) * Double(soap.waterP/100)
        }
        
        soap.waterWeight = water
        soap.totalWeight = water + lye + soap.totalOilWeight
    }
    
}

extension WaterController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return methods.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return methods[row][0]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        methodUnit.text = methods[row][1] as String
        selectedMethod = methods[row][0] as String
    }
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        checkField()
    }
    
    func checkField() {
        if waterPTextView.text!.isEmpty {
            calculateButton.isEnabled = false
            calculateButton.backgroundColor = .systemGray
        }
        else{
            calculateButton.isEnabled = true
            calculateButton.backgroundColor = greenColor
        }
    }
}
