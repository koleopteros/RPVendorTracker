//
//  InventoryTableHandler.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-04-02.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation
import SQLite3
class InventoryTableHandler{
    var db: OpaquePointer?
    let handler = DatabaseHandler()
    
    public func createInventoryTable(){
        let query = "CREATE TABLE IF NOT EXISTS inventory (vendors_id INTEGER NOT NULL REFERENCES vendors(id), items_id INTEGER NOT NULL REFERENCES items(id), quantity INTEGER NOT NULL, PRIMARY KEY (vendors_id, items_id)"
        
        if sqlite3_open(handler.fileURL.path, &db) != SQLITE_OK {
            print("failed to open db")
        }
        if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    public func retrieveInventory(vendor_id:Int){
        let query = "SELECT items.name AS item_name, inventory.quantity AS quantity FROM inventory"
    }
}

