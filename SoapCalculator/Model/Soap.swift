import Foundation
import RealmSwift

class Soap: Object{
    @objc dynamic var name: String?
    @objc dynamic var isLiquid: Bool = false
    @objc dynamic var date: String?
    @objc dynamic var tag: String?
    @objc dynamic var superfatting: String?
    @objc dynamic var unit: String?
    @objc dynamic var waterMethod: String?
    @objc dynamic var fragrance: String?
    @objc dynamic var waterP: Double = 0.0
    @objc dynamic var waterWeight: Double = 0.0
    @objc dynamic var lyeOrKWeight: Double = 0.0
    @objc dynamic var totalOilWeight: Double = 0.0
    @objc dynamic var totalWeight: Double = 0.0
    let oilNamesList = List<String>()
    let oilWeightsList = List<Double>()
    var oilNames : [String] = []
    var oilWeights : [Double] = []
    
    
    init(name: String, isLiquid: Bool, date: String, tag: String) {
        self.name = name
        self.isLiquid = isLiquid
        self.date = date
        self.tag = tag
    }
    
    required override init(){
    }
}
