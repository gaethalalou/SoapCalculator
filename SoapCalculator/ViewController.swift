import UIKit

class ViewController: UIViewController {
    let indepColor = UIColor(red: CGFloat(61.0/255.0), green: CGFloat(64.0/255.0), blue: CGFloat(91.0/255.0), alpha: CGFloat(1.0))
    let eggshellColor = UIColor(red: CGFloat(244.0/255.0), green: CGFloat(241.0/255.0), blue: CGFloat(222.0/255.0), alpha: CGFloat(1.0))
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var soapTabelView: UITableView!
    
    let soaps = [["Lavender Olive Oil", "soap", "Cheap", "01/23/2021"], ["Cinnamon Almond", "lSoap", "Cold", "11/15/2020"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        soapTabelView.delegate = self
        soapTabelView.dataSource = self
        searchBar.searchTextField.backgroundColor = indepColor
        searchBar.searchTextField.leftView?.tintColor = eggshellColor


    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = soapTabelView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        let soap = soaps[indexPath.row]
    
        cell.typeImg.image = UIImage(named: soap[1])
        cell.titleLabel.text = soap[0]
        cell.tagLabel.text = "  \(soap[2])  "
        cell.dateLabel.text = soap[3]
        
        return cell
    }
    
    
}
