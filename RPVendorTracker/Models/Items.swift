//
//  Items.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation

class Items: ListInterface {
    
    var id: Int = 0
    var name: String = ""
    var desc: String = ""
    var weight: Float = 0.0
    var rarity: Int = 0
    var category: Int = 0
    
    init(id: Int, name: String, desc: String, weight: Float, rarity: Int, category: Int){
        self.id=id
        self.name=name
        self.desc=desc
        self.weight=weight
        self.rarity=rarity
        self.category=category
    }
    func getName() -> String {
        return self.name
    }
    func setName(name: String) {
        self.name = name
    }
    
    func getDesc() -> String {
        return self.desc
    }
    
    func setDesc(desc: String) {
        self.name=desc
    }
    
    func getWeight() -> Float {
        return self.weight
    }
    func getCellDetail() -> String {
        return String(self.weight)
    }
    func getCellImg() -> String {
        return String(self.category)
    }
}
