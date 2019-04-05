//  Student ID: 100530184
//  DatabaseHandler.swift
//  RPVendorTracker
//
//  Created by Jerome Ching.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//
//  Forgot to generate a UserTableHandler... so its gonna go in here

import Foundation
import SQLite3
class DatabaseHandler {
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("appDB.sqlite")

    let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    let vendors = VendorsTableHandler()
    let items = ItemsTableHandler()
    let inventory = InventoryTableHandler()
    
    init(){
    }
    public func setup(){
    
    }
}
