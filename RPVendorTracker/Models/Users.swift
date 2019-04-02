//
//  Users.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-04-02.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation

class Users {
    let id: Int
    let name: String
    let password: String
    init(id: Int){
        self.id = id
        self.name = ""
        self.password = ""
    }
    init(id: Int, name: String, password:String){
        self.id = id
        self.name = name
        self.password = password
    }
}
