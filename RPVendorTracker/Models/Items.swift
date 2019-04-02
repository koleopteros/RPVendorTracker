//  Student ID: 100530184
//  Items.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation

class Items: ListInterface {
    let CATEGORIES = ["Food","Tools","Weapons","Junk"]
    var id: Int = 0
    var name: String = ""
    var desc: String = ""
    var weight: Float = 0.0
    var rarity: Int = 0
    var category: Int = 0
    init(){
        
    }
    init(id: Int, name: String, desc: String, weight: Float, rarity: Int, category: Int){
        self.id=id
        self.name=name
        self.desc=desc
        self.weight=weight
        self.rarity=rarity
        self.category=category
    }
    init(obj: [String: Any]){
        self.id=obj["id"] as! Int
        self.name=obj["name"] as! String
        self.desc=obj["desc"] as! String
        self.weight=obj["weight"] as! Float
        self.rarity=obj["rarity"] as! Int
        self.category=obj["category"] as! Int
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
    func getCategories() -> [String] {
        return self.CATEGORIES
    }
    func getCellDetail() -> String {
        return String(self.weight)
    }
    func getCellImg() -> String {
        return String(self.category)
    }
    func dataDump() -> [String : Any] {
        var data = [String : Any]()
        data["id"] = self.id
        data["name"] = self.name
        data["desc"] = self.desc
        data["weight"] = self.weight
        data["rarity"] = self.rarity
        data["category"] = self.category
        return data
    }
}
