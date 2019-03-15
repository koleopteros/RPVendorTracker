//
//  Inventory.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation

class Inventory {
    var owner: Vendors {
        get{ return self.owner }
        set(newOwner){ self.owner = newOwner }
    }
    var items: [Int: Int] {
        get{ return self.items }
        set(items){ self.items = items}
    }
    init(vendor: Vendors, items:[Int: Int]){
        owner = vendor
        self.items = items
    }
    public func size() -> Int {
        return items.count
    }
}
