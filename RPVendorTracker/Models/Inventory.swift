//
//  Inventory.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-04-02.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation

struct Inventory {
    var id:Int?
    var vendorID: Int?
    var stock: [Int:Int] = [Int:Int]()
}
