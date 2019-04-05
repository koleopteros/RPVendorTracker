//  Student ID: 100530184
//  ItemsTableHandler.swift
//  RPVendorTracker
//
//  Created by Jerome Ching.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation
import SQLite3

class ItemsTableHandler{
    var db:OpaquePointer?
    
    public func createItemsTable(){
        let createString = "CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, desc TEXT, weight REAL, rarity INTEGER, category INTEGER)"
        
        let handler = DatabaseHandler()
        
        if sqlite3_open(handler.fileURL.path, &db) != SQLITE_OK {
            print("failed to open db")
        }
        if sqlite3_exec(db, createString, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    /** insertitems
        inserts a new row into items
        returns true on success
        @params Items object
        @returns Bool
    */
    public func insertItems(i:Items){
        let query = "INSERT INTO items (name,desc,weight,rarity,category) VALUES (\(i.name),\(i.desc),\(i.weight),\(i.rarity),\(i.category))"

        if sqlite3_prepare_v2(db,query,-1,&stmt,nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Inserted Item row")
                return true
            } else {
                print("Failed to insert item:  \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Failed to prep:  \(String(cString: sqlite3_errmsg(db)))")
        }
        return false
    }

    /** retrieveItems
        returns a list of all existing items
        @returns [Items]
    */
    public func retrieveItems() -> [Items] {
        let query = "SELECT * FROM vendors"
        var stmt: OpaquePointer?
        var list: [Items] = [Items]()
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error prepping table: \(errmsg)")
            return [Items]()
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = Int(sqlite3_column_int(stmt,0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let desc = String(cString: sqlite3_column_text(stmt, 2))
            let weight = Float(sqlite3_column_double(stmt, 3))
            let rarity = Int(sqlite3_column_int(stmt,4))
            let category = Int(sqlite3_column_int(stmt,5))
            
            list.append(Items(id: id, name: name, desc: desc, weight: weight, rarity: rarity, category: category))
        }
        return list
    }
}
