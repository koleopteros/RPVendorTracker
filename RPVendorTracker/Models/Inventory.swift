//
//  Inventory.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation

class Inventory {
    var owner: Int {
        get{ return self.owner }
        set(newOwner){ self.owner = newOwner }
    }
    var items: [Int: Int] {
        get{ return self.items }
        set(items){ self.items = items}
    }
    init(vendorID:Int){
        owner = vendorID
        self.items = [Int:Int]()
    }
    init(vendorID: Int, items:[Int: Int]){
        owner = vendorID
        self.items = items
    }
    public func itemIncrement(itemID:Int){
        items[itemID] = items[itemID]!+1
    }
    public func itemDecrement(itemID:Int){
        items[itemID] = items[itemID]!-1
    }
    public func addItem(itemID:Int, newQuantity:Int){
        items[itemID] = newQuantity
    }
    public func size() -> Int {
        return items.count
    }
    
}
