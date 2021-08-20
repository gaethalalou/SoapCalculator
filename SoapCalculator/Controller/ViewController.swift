import UIKit
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var soapTabelView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    let indepColor = UIColor(red: CGFloat(61.0/255.0), green: CGFloat(64.0/255.0), blue: CGFloat(91.0/255.0), alpha: CGFloat(1.0))
    let eggshellColor = UIColor(red: CGFloat(244.0/255.0), green: CGFloat(241.0/255.0), blue: CGFloat(222.0/255.0), alpha: CGFloat(1.0))
    var soaps: [Soap]!
    var filteredData: [Soap]!
    var soap: Soap!
    var realm: Realm!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        searchBar.delegate = self
        soapTabelView.delegate = self
        soapTabelView.dataSource = self
        
        searchBar.searchTextField.backgroundColor = indepColor
        searchBar.searchTextField.textColor = eggshellColor
        searchBar.searchTextField.leftView?.tintColor = eggshellColor
        
        realm = try! Realm()
        self.isAppAlreadyLaunchedOnce()
        
        soaps = Array(realm.objects(Soap.self))
        soaps.reverse()
        filteredData = soaps
        
        //        print(Realm.Configuration.defaultConfiguration.fileURL) will print path for realm database
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.addButton.transform = self.addButton.transform.rotated(by: CGFloat(Double.pi/2))
        }, completion: { _ in
            self.performSegue(withIdentifier: "goToAdd", sender: self)
        })
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = soapTabelView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        let soap = filteredData[indexPath.row]
        cell.soap = soap
        cell.typeImg.image = UIImage(named: (soap.isLiquid ? "lSoap" : "soap"))
        cell.titleLabel.text = soap.name
        cell.tagLabel.text = soap.tag
        cell.dateLabel.text = soap.date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let cell = soaps[indexPath.row]
            soaps.remove(at: indexPath.row)
            filteredData.remove(at: indexPath.row)
            soapTabelView.reloadData()
            
            try! realm.write{
                realm.delete(cell)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = soapTabelView.cellForRow(at: indexPath) as! CustomCell
        soap = cell.soap
        self.performSegue(withIdentifier: "goToRecipe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToRecipe") {
            let vc = segue.destination as! resultRecipeController
            vc.isFromWater = false
            vc.soap = soap
        }
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText != "" {
            for soap in soaps {
                if soap.name!.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(soap)
                } else if(soap.tag!.lowercased().contains(searchText.lowercased()) && !filteredData.contains(soap)){
                    filteredData.append(soap)
                }
            }
        } else{
            filteredData = soaps
        }
        self.soapTabelView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.realm.refresh()
                self.soaps = Array(self.realm.objects(Soap.self))
                self.soaps.reverse()
                self.filteredData = self.soaps
                self.soapTabelView.reloadData()
            }
        }
    }
    
    func isAppAlreadyLaunchedOnce(){
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            copyData()
        }
    }
    
    func copyData(){
        if let path = Bundle.main.path(forResource: "oils", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                for i in 0..<myStrings.count-1 {
                    let line = myStrings[i]
                    let words = line.components(separatedBy: ", ")
                    try! realm.write{
                        realm.add(Oil(name: words[0], lye: Double(words[1])!, koh: Double(words[2])!))
                    }
                }
            } catch {
                print(error)
            }
        } else{
            print("error reading file")
        }
    }
}
