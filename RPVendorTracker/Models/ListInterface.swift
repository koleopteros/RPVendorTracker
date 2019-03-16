//
//  ListInterface.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation

protocol ListInterface {
    func getName() -> String
    func getDesc() -> String
    func getWeight() -> Float
    func getCellDetail() -> String
    func getCellImg() -> String
    func dataDump() -> [String:Any]
}
