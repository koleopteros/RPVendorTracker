//  Student ID: 100530184
//  VendorsTableHandler.swift
//  RPVendorTracker
//
//  Due to time constraints...
//  Vendors will only have Create, and Read operations
//  Inventory can still be updated via the inventory handler.
//
//  Created by Jerome Ching.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation
import SQLite3

class VendorsTableHandler{
    var db: OpaquePointer?
    
    let handler = DatabaseHandler()
    let invHandler = InventoryTableHandler()
    
    public func createVendorsTable(){
        let createString = "CREATE TABLE IF NOT EXISTS vendors (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, desc TEXT, weight REAL, race TEXT, age INTEGER, gender INTEGER, inventoryID INTEGER, FOREIGN KEY (inventoryID) REFERENCES inventories(id))"
        
        if sqlite3_open(handler.fileURL.path, &db) != SQLITE_OK {
            print("failed to open db")
        }
        if sqlite3_exec(db, createString, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    /** insertVendor
        inserts new row with vendor's information
        Returns true for success
        @params Vendor Object
        @returns Bool
    */
    public func insertVendor(v:Vendors)->Bool{
        let query = "INSERT INTO vendors (name,desc,weight,race,age,gender) VALUES (\(v.name),\(v.desc),\(v.weight),\(v.race),\(v.age),\(v.gender?1:0))"

        if sqlite3_prepare_v2(db,query,-1,&stmt,nil) == SQLITE_OK{
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Inserted Vendor row")
                return true
            } else {
                print("Failed to insert row: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Failed to prep statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        return false
    }
    /** retrieveVendors
        gets full list of all existing vendors
        @returns [Vendors]
    */
    public func retrieveVendors() -> [Vendors] {
        let query = "SELECT * FROM vendors"
        var stmt: OpaquePointer?
        var list: [Vendors] = [Vendors]()
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error prepping table: \(errmsg)")
            return [Vendors]()
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = Int(sqlite3_column_int(stmt,0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let desc = String(cString: sqlite3_column_text(stmt, 2))
            let weight = Float(sqlite3_column_double(stmt, 3))
            let race = String(cString: sqlite3_column_text(stmt, 4))
            let age = Int(sqlite3_column_int(stmt, 5))
            let gender = Bool(sqlite3_column_int(stmt, 6) == 1 ? true : false)
            let inventory = invHandler.retrieveInventory(id)
            
            
            list.append(Vendors(id: id, name: name, desc: desc, weight: weight, race: race, age: age, gender: gender, inventory: inventory))
        }
        return list
    }
}
