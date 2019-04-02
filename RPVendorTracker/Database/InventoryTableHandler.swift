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
        let query = "CREATE TABLE IF NOT EXISTS inventories (id INTEGER PRIMARY KEY AUTOINCREMENT, vendor_id INTEGER, FOREIGN KEY (vendor_id) REFERENCES vendors(id))"
        
        if sqlite3_open(handler.fileURL.path, &db) != SQLITE_OK {
            print("failed to open db")
        }
        if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    public func createInventoryItemsTable(){
        let query = "CREATE TABLE IF NOT EXISTS inventory_items (inventory_id INTEGER NOT NULL REFERENCES inventories(id), item_id INTEGER NOT NULL items(id), PRIMARY KEY (inventory_id, item_id)"
        let handler = DatabaseHandler()
        
        if sqlite3_open(handler.fileURL.path, &db) != SQLITE_OK {
            print("failed to open db")
        }
        if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    public func retrieveInventoryList(inventoryID:Int) -> [Int:Int] {
        var list = [Int:Int]()
        
        let query = "SELECT * from inventory_items WHERE inventory_id = ?"
        
        return list
    }
}

