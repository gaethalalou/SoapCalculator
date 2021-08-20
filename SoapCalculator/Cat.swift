//
//  Cat.swift
//  SoapCalculator
//
//  Created by Gaeth Alalou on 2/25/21.
//

import Foundation
import RealmSwift

class Cat: Object{
    @objc var name: String?
    @objc var color: String?
    @objc var gender: String?
    
    init(name: String, color: String, gender: String) {
        self.name = name
        self.color = color
        self.gender = gender
    }
    
    required override init(){
        
    }
}
