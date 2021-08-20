import UIKit

class OilWeightController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var oilWeightTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    var units : [[String]] = [["Ounces (oz)", "oz"], ["Pounds (lb)", "lb"], ["Grams (g)", "g"], ["Kilograms (kg)", "kg"]]
    let greenColor = UIColor(red: CGFloat(129.0/255.0), green: CGFloat(178.0/255.0), blue: CGFloat(154.0/255.0), alpha: CGFloat(1.0))
    var oils : [String] = []
    var unit : String!
    var soap : Soap!
    var oilAmounts : [Double] = []
    var totalOilWeight : Double = 0.0
    var cellArray : [OilWeightCustomCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        oilWeightTableView.delegate = self
        oilWeightTableView.dataSource = self
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(2, inComponent: 0, animated: true)
        unit = units[2][1]
        oils = soap.oilNames
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        soap.oilNames = []
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        totalOilWeight = 0.0
        oilAmounts = []
        for i in 0...oils.count{
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = oilWeightTableView.cellForRow(at: indexPath) as? OilWeightCustomCell {
                let str = String(cell.weightTextfield.text ?? "")
                if !str.isEmpty {
                    let oilWeight = Double(str)!
                    totalOilWeight += oilWeight
                    oilAmounts.append(oilWeight)
                }
            }
        }
        
        if oilAmounts.count == oils.count {
            self.performSegue(withIdentifier: "goToWater", sender: self)
        } else {
            totalOilWeight = 0.0
            oilAmounts = []
            let alert = UIAlertController(title: "Alert", message: "Please Enter Oil Weights", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToWater") {
            let vc = segue.destination as! WaterController
            soap.oilWeights = oilAmounts
            soap.unit = unit
            soap.totalOilWeight = totalOilWeight
            vc.soap = soap
            oilAmounts = []
        }
    }
}

extension OilWeightController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oils.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = oilWeightTableView.dequeueReusableCell(withIdentifier: "oilWeightCell") as! OilWeightCustomCell
        let oil = oils[indexPath.row]
        cell.oilLabel.text = oil
        cell.unitLabel.text = unit
        cellArray.append(cell)
        return cell
    }
    
    func checkField(cell: OilWeightCustomCell) {
        if ((cell.weightTextfield.text?.isEmpty) != nil) {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .systemGray
        }
        else{
            nextButton.isEnabled = true
            nextButton.backgroundColor = greenColor
        }
    }
}

extension OilWeightController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row][0]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unit = units[row][1] as String
        oilWeightTableView.reloadData()
    }
}
