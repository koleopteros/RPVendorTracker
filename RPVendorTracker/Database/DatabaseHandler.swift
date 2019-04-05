//
//  DatabaseHandler.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-04-02.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation
import SQLite3
class DatabaseHandler {
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("appDB.sqlite")
    let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    let vendorsHandler = VendorsTableHandler()
    let itemsHandler = ItemsTableHandler()
    init(){
    }
    public func setup(){
    
    }
}
