//  Student ID: 100530184
//  Vendors.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation

class Vendors: ListInterface, Equatable{
    var id: Int = 0
    var name: String = ""
    var desc: String = ""
    var weight: Float = 0.0
    var race: String = ""
    var age: Int = 0
    var gender: Bool = true
    var inventory: [Int:Int]?
    //imagefile currently unused
    var imageFile: String = ""
    init(){}
    init(_ id:Int){
        self.id = id
    }
    init(id:Int,name:String,desc:String, weight:Float,race:String,age:Int,gender:Bool){
        self.id = id
        self.name=name
        self.desc=desc
        self.weight=weight
        self.race=race
        self.age=age
        self.gender=gender
        inventory = [:]
    }
    init(id:Int,name:String,desc:String, weight:Float,race:String,age:Int,inventory: [Int:Int]?){
        self.id = id
        self.name=name
        self.desc=desc
        self.weight=weight
        self.race=race
        self.age=age
        self.gender=true
        self.inventory=inventory
    }
    init(id:Int,name:String,desc:String, weight:Float,race:String,age:Int,gender:Bool,inventory: [Int:Int]?){
        self.id = id
        self.name=name
        self.desc=desc
        self.weight=weight
        self.race=race
        self.age=age
        self.gender=gender
        self.inventory=inventory
    }
    init(obj: [String:Any]){
        self.id = obj["id"] as! Int
        self.name=obj["name"] as! String
        self.desc=obj["desc"] as! String
        self.weight=obj["weight"] as! Float
        self.race=obj["race"] as! String
        self.age=obj["age"] as! Int
        self.gender=(obj["gender"] != nil)
        self.inventory=obj["inventory"] as? [Int : Int]
    }
    func updateItem(itemID:Int, quantity:Int){
        inventory![itemID] = quantity
    }
    func incrementItem(itemID:Int){
        inventory![itemID] = inventory![itemID]!+1
    }
    func decrementItem(itemID:Int){
        inventory![itemID] = inventory![itemID]!-1
    }
    func getName() -> String {
        return self.name
    }
    func getDesc() -> String {
        return self.desc
    }
    func getWeight() -> Float {
        return self.weight
    }
    func getInventoryCount() -> Int{
        var count = 0;
        if inventory != [:]{
            for quantity in (inventory?.values)!{
                count = count + quantity
            }
        }
        return count
    }
    func getCellDetail() -> String {
        if gender{
            return "Male, \(self.age) years old"
        }else{
            return "Female, \(self.age) years old"
        }
    }
    func getCellImg() -> String {
        return imageFile
    }
    func dataDump() -> [String:Any]{
        var data = [String:Any]()
        data["id"] = self.id
        data["name"] = self.name
        data["desc"] = self.desc
        data["weight"] = self.weight
        data["race"] = self.race
        data["age"] = self.age
        data["gender"] = self.gender
        data["inventory"] = self.inventory
        return data
    }
    static func == (lhs: Vendors, rhs: Vendors) -> Bool {
        return lhs.id == rhs.id
    }
}
