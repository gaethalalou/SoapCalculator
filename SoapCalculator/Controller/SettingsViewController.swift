import UIKit
import RealmSwift

class SettingsViewController: UIViewController {
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
    }
    
    @IBAction func eraseItemsPressed(_ sender: Any) {
        try! realm.write {
            let all = realm.objects(Soap.self)
            realm.delete(all)
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "exitSettings", sender: self)
    }
}
