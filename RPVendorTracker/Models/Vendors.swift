//
//  Vendors.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation

class Vendors: ListInterface{
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
    func getCellDetail() -> String {
        if gender{
            return "Male, \(self.age)"
        }else{
            return "Female, \(self.age)"
        }
    }
    func getCellImg() -> String {
        return imageFile
    }
}
