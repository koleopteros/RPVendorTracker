//  Student ID: 100530184
//  InventoryTableHandler.swift
//  RPVendorTracker
//
//  Created by Jerome Ching.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation
import SQLite3
class InventoryTableHandler{
    var db: OpaquePointer?
    let handler = DatabaseHandler()
    /** createInventoryTable
        creates the table... i dunno what else to say
    */
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
    /** findInventory
        Checks if inventory exists, returns true on successful search
        @params vendor_id, items_id
        @returns Bool
      */
    public func findInventory(vendor_id:Int, items_id:Int){
        let query = "SELECT * FROM inventory INNER JOIN inventory ON inventory.vendors_id = \(vendor_id) AND inventory.items_id = \(items_id)"

        if sqlite3_prepare_v2(db,query,-1,&stmt,nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                print("Found match!")
                return true
            } else {
                print("No match found!")
            }
        } else {
            print("Failed to prepare statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        return false
    }
    /** insertInventory
        inserts a row of Inventory with the appropriate vendor, item and quantity
        Returns true on success, otherwise false
        @params vendor_id, items_id, quantity
        @returns Bool
    */
    public func insertInventory(vendor_id:Int, items_id:Int, quantity:Int) -> Bool{
        let query = "INSERT INTO inventory (vendors_id, items_id, quantity) VALUES (\(vendor_id),\(items_id),\(quantity)"

        if sqlite3_prepare_v2(db,query,-1,&stmt,nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Inserted Row Vendor: \(vendor_id), Item: \(items_id), Quantity: \(quantity)")
                return true
            } else {
                print("Failed to Insert: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Failed to prepare statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        return false
    }
    /** insertInventories
        Bulk insertion.
        Returns -1 for failed prep, or a count for number of successful insertions
        @params vendor_id, inventoryList
        @returns Int
    */
    public func insertInventory(vendor_id:Int, inventoryList:[Items:Int]) -> Int{
        var insertionCount = 0
        for item in inventoryList.keys {
            let query = "INSERT INTO inventory (vendors_id, items_id, quantity) VALUES (\(vendor_id),\(item.id),\(inventoryList[item])"
            if sqlite3_prepare_v2(db,query,-1,&stmt,nil) == SQLITE_OK {
                if sqlite3_step(stmt) == SQLITE_DONE {
                    print("Inserted Row Vendor: \(vendor_id), Item: \(items_id), Quantity: \(quantity)")
                    insertionCount++
                } else {
                    print("Failed to Insert: \(String(cString: sqlite3_errmsg(db)))")
                }
            } else {
                print("Failed to prepare statement: \(String(cString: sqlite3_errmsg(db)))")
                insertionCount = -1
            }
        }
        return insertionCount
    }
    /** updateInventory
        Searches for matching vendorID and itemsID and updates that row's quantity
        If quantity is 0, delete the row
        @params vendor_id, items_id, quantity
        @returns Bool
    */
    public func updateInventory(vendor_id:Int, items_id:Int, quantity:Int){
        let query = "UPDATE inventory SET quantity = \(quantity) WHERE vendors_id = \(vendor_id) AND items_id = \(items_id)"
        if quantity == 0 {
            return deleteInventory(vendor_id:vendor_id, items_id:items_id)
        }
        if sqlite3_prepare_v2(db,query,-1,&stmt,nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Updated Vendor: \(vendor_id), Item: \(items_id), Quantity: \(quantity)")
                return true
            } else {
                print("Failed to Update: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Failed to prepare statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        return false
    }
    /** deleteInventory
        deletes row with matching vendor and item ID
        @params vendor_id, items_id
        @returns Bool
    */
    public func deleteInventory(vendor_id:Int, items_id:Int){
        let query = "DELETE FROM inventory WHERE vendors_Id = \(vendor_id) AND items_id = \(items_id);"

        if sqlite3_prepare_v2(db,query,-1,&stmt,nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Deleted Row: \(vendor_id),\(items_id)")
                return true
            } else {
                print("Failed to Delete: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Failed to prepare statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        return false
    }
    /** retrieveInventory
        searches for all rows that have matching vendor_id and constructs a dictionary representing the vendor's "inventory"
        @params vendor_id
        @returns [Items:Int]
    */
    public func retrieveInventory(vendor_id:Int)->[Items:Int]{
        var quantity: Int?
        var id: Int?
        var name: String?
        var desc: String?
        var weight: Float?
        var rarity: Int?
        var category: Int?

        var list = [Items:Int]()

        let query = "SELECT inventory.quantity, items.id, items.name, items.desc, items.weight, items.rarity, items.category FROM items INNER JOIN inventory ON inventory.vendor_id = \(vendor_id)"

        if sqlite3_prepare_v2(db,query,-1,&stmt,nil) != SQLITE_OK {
            let e = String(cString: sqlite3_errmsg(db)!)
            print("Error prepping statement: \(e)")
            return [Items:Int]()
        }
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            quantity = Int(sqlite3_column_int(stmt,0))
            id = Int(sqlite3_column_int(stmt,1))
            name = String(cString: sqlite3_column_text(stmt,2))
            desc = String(cString: sqlite3_column_text(stmt,3))
            weight = Float(sqlite3_column_double(stmt,4))
            rarity = Int(sqlite3_column_int(stmt,5))
            category = Int(sqlite3_column_int(stmt,6))
            list[Items(id: id, name: name, desc: desc, weight: weight, rarity: rarity, category: category] = quantity
        }
        return list
    }
}

