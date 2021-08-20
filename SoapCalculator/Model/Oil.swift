import Foundation
import RealmSwift

class Oil: Object{
    @objc dynamic var name: String?
    @objc dynamic var lye: Double = 0.0
    @objc dynamic var koh: Double = 0.0
    
    init(name: String, lye: Double, koh: Double) {
        self.name = name
        self.lye = lye
        self.koh = koh
    }
    
    required override init(){
    }
}
