//  Student ID: 100530184
//  ViewController.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var ListView: UITableView!
    
    let userID = UserDefaults.standard.integer(forKey: "userID")
    
    var newVendor: Vendors?{
        didSet{
            if newVendor != nil {
                openDB()
                //self.vendorDummyData.append(newVendor!)
                self.insertIntoVendors(v: newVendor!)
                self.loadTablesToLists()
                if ListView != nil{
                    self.ListView.reloadData()
                }
            }
        }
    }
    var newItem: Items? {
        didSet{
            if newItem != nil {
                openDB()
                //self.itemsDummyData.append(newItem!)
                self.insertIntoItems(i: newItem!)
                self.loadTablesToLists()
                if ListView != nil{
                    self.ListView.reloadData()
                }
            }
        }
    }
    var db:OpaquePointer?
    
    var dataInterface: [ListInterface] = []
    
    // Dummy data
//    var vendorDummyData: [Vendors] = []
//    var itemsDummyData: [Items] = []
//    var myVendorsDummyData: [Vendors] = []
    
    // DB data
    var vendorsDBData: [Vendors] = []
    var itemsDBData: [Items] = []
    var myVendorsDBData: [Vendors] = []
    
    var pickerSelection: Vendors?

    var currentSegment: Int = 0
    let segmentNames = ["Vendors","Items","My Vendors"]
    
    override func viewDidLoad() {
        //Open DB and load up DBData arrays
        self.openDB()
        self.loadTablesToLists()
        dataInterface = vendorsDBData
        
        //filling Dummy data, set default list to vendors
        //self.fillDummyData()
        //dataInterface = vendorDummyData
        super.viewDidLoad()
        
        addButton.titleLabel?.text = "Add Vendor"
        addButton.addTarget(self, action: #selector(addButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        
        //setting TableView's delegate and datasource
        ListView.delegate = self
        ListView.dataSource = self
        
        /* Segment control section */
        let segmentCtrl = UISegmentedControl(items:segmentNames)
        segmentCtrl.frame = CGRect(
            x:0,
            y:30,
            width:self.view.frame.width,
            height:40)
        segmentCtrl.addTarget(self,action:
            #selector(ViewController.indexChanged(_:)), for:.valueChanged)
        segmentCtrl.tintColor = UIColor.blue
        segmentCtrl.selectedSegmentIndex = 0
        self.view.addSubview(segmentCtrl)
        
        updateAddButton()
    }
    @IBAction func addButtonClicked(_ sender: UIButton) {
        if currentSegment != 2{
            self.performSegue(withIdentifier: "MainToNewObjSegue", sender: self)
        } else {
            print("Button Clicked, \(currentSegment)")
            let alertCtrl = UIAlertController(title:"My Vendors", message:"Add an existing vendor to your list", preferredStyle: UIAlertControllerStyle.alert)
            alertCtrl.view.addConstraint(NSLayoutConstraint(item: alertCtrl.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.bounds.height*0.5))
            // creating pickerviewer
            let picker: UIPickerView = UIPickerView(frame: CGRect(x: 10, y: view.bounds.height*0.125, width: 250, height: 120))
            picker.delegate = self
            picker.dataSource = self
            alertCtrl.view.addSubview(picker)
            self.present(alertCtrl,animated: true,completion: nil)
            let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
                if self.pickerSelection != nil {
                    self.insertIntoMyVendors(user_id: self.userID, vendor_id: self.pickerSelection!.id - 1)
                    self.loadMyVendors()
                    self.dataInterface = self.myVendorsDBData
                    //self.myVendorsDummyData.append(self.pickerSelection!)
                    //print(self.myVendorsDummyData.count)
                    //updating data in datainterface
                    //self.dataInterface = self.myVendorsDummyData
                    self.ListView.reloadData()
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {(action) -> Void in })
            alertCtrl.addAction(submitAction)
            alertCtrl.addAction(cancelAction)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "mainToDetails" {
            if let indexPath = ListView.indexPathForSelectedRow {
                let destVC = segue.destination as! DetailsViewController
                destVC.dataInterface = self.dataInterface[indexPath.item]
                destVC.itemsDBData = self.itemsDBData
            }
        }
        if segue.identifier == "MainToNewObjSegue" {
            let destVC = segue.destination as! FormViewController
            print("Segue to new Obj View")
            destVC.dataType = self.currentSegment%2
            destVC.vendorCount = self.vendorsDBData.count
            destVC.itemCount = self.itemsDBData.count
            print("Sending dataType Value: \(self.currentSegment)")
        }
    }
    @objc func indexChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 1:
            currentSegment = 1
            dataInterface = itemsDBData
            print(segmentNames[1]+" data count: "+String(getDataCount()))
            self.ListView.reloadData()
            updateAddButton()
            break
        case 2:
            currentSegment = 2
            dataInterface = myVendorsDBData
            print(segmentNames[2]+" data count: "+String(getDataCount()))
            self.ListView.reloadData()
            updateAddButton()
            break
        default:
            currentSegment = 0
            dataInterface = vendorsDBData
            print(segmentNames[0]+" data count: "+String(getDataCount()))
            self.ListView.reloadData()
            updateAddButton()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getDataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItem", for: indexPath)
        cell.textLabel?.text = dataInterface[indexPath.item].getName()
        cell.detailTextLabel?.text = dataInterface[indexPath.item].getCellDetail()
        return cell
    }
    
    func getDataCount()->Int{
        switch currentSegment{
        case 1:
            return itemsDBData.count
        case 2:
            return myVendorsDBData.count
        default:
            return vendorsDBData.count
        }
    }
    
    func updateAddButton(){
        if currentSegment == 1 {
            addButton.setTitle("Add Item", for: UIControlState.normal)
        }else if currentSegment == 0{
            addButton.setTitle("Add Vendor", for: UIControlState.normal)
        }else {
            addButton.setTitle("Add Vendor To List", for: UIControlState.normal)
        }
    }
    
    // PickerView methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vendorsDBData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vendorsDBData[row].getName()
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if myVendorsDBData.contains(where: {$0 == vendorsDBData[row]}){
            pickerSelection = nil
        }else{
            pickerSelection = vendorsDBData[row]
        }
    }
    
//    func fillDummyData(){
//        //Generating Dummy Data for Vendors
//        vendorDummyData.append(Vendors(id:1,name:"Bob Ross",desc:"Master painter and artist",weight:121.5,race:"Human",age:900,gender:true))
//        vendorDummyData.append(Vendors(id:2,name:"Jack Daniels",desc:"Whiskey whiskey whiskey",weight:999.5,race:"Human",age:200,gender:true))
//        vendorDummyData.append(Vendors(id:3,name:"P Pawluk",desc:"super mobile and agile",weight:148.5,race:"Human",age:35,gender:true))
//        vendorDummyData.append(Vendors(id:4,name:"Mike D",desc:"Super edgy and full of stacks",weight:128.5,race:"Human",age:28,gender:true))
//        vendorDummyData.append(Vendors(id:5,name:"Mark K",desc:"Neuralmancy specialist",weight:110.8,race:"Human",age:31,gender:true))
//        vendorDummyData.append(Vendors(id:6,name:"V Bilijana",desc:"Data Storage specialist",weight:100.8,race:"Human",age:40,gender:false))
//        vendorDummyData.append(Vendors(id:6,name:"Anjana S",desc:"Hat and rock specialist",weight:87.8,race:"Human",age:40,gender:false))
//        vendorDummyData.append(Vendors(id:7,name:"Kareem A",desc:"Network, Security, and Survival specialist",weight:140.8,race:"Human",age:30,gender:true))
//
//        // Generating Dummy data for Items
//        itemsDummyData.append(Items(id:1,name:"Bottle of Water", desc:"water in a bottle", weight:1, rarity:1, category:1))
//        itemsDummyData.append(Items(id:2,name:"Caltrops", desc:"Very spiky.  Don't touch!", weight:2, rarity:1, category:2))
//        itemsDummyData.append(Items(id:3,name:"Mooing steak", desc:"I don't think its ready to eat...", weight:3, rarity:2, category:1))
//        itemsDummyData.append(Items(id:4,name:"Bars of Milk Chocolate", desc:"Packed full of sugar and cocoa!", weight:5, rarity:3, category:1))
//        itemsDummyData.append(Items(id:5,name:"Short Sword", desc:"Its a sword that is short", weight:1.6, rarity:1, category:3))
//        itemsDummyData.append(Items(id:6,name:"Throwing Knives", desc:"Comes in a 5-pack", weight:3, rarity:1, category:2))
//        itemsDummyData.append(Items(id:7,name:"Make-up kit thing", desc:"For those who need that Foundation", weight:1, rarity:2, category:2))
//        itemsDummyData.append(Items(id:8,name:"Broken iPhone", desc:"Extremely expensive smartphone from some other world.  What's a smartphone you say?  Heck if I know.  Looks fancy and stuff.", weight:2, rarity:5, category:3))
//        itemsDummyData.append(Items(id:9,name:"Backpack", desc:"Its a bag.  It holds stuff.  I don't know what else to say...", weight:3, rarity:1, category:2))
//        itemsDummyData.append(Items(id:10,name:"Dark Spectacles", desc:"Ever wanted to block out the light? Well these spectacles are for you!  Wear them and deny the sun any place in your eyes.", weight:1, rarity:2, category:3))
//        itemsDummyData.append(Items(id:11,name:"Gummy Bears", desc:"gummy bears... very chewy and packed with very little sugar", weight:1, rarity:2, category:1))
//
//        // just taking slots 2-5 for "my vendors"
//        for i in 2...5{
//            myVendorsDummyData.append(vendorDummyData[i])
//        }
//
//        // assign random inventory to vendors.  Until Core Data is implemented, this data will constantly change.
//        for vendor in vendorDummyData{
//            for _ in 0...Int(arc4random_uniform(6)){
//                vendor.inventory![Int(arc4random_uniform(UInt32(itemsDummyData.count-1))+1)] = Int(arc4random_uniform(4))+1
//            }
//        }
//    }
    /*--------------- DATABASE  --------------*/
    private func openDB() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("appDB.sqlite")
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Opened DB!")
        } else {
            print("Failed to open DB!")
        }
    }
    private func loadTablesToLists(){
        loadVendors()
        loadItems()
        for vendor in vendorsDBData{
            loadInventory(vendor_id: vendor.id)
        }
        loadMyVendors()
    }
    /*------ INSERT Methods -------*/
    private func insertIntoVendors(v:Vendors){
        var stmt:OpaquePointer?
        let query = "INSERT INTO vendors (name,desc,weight,race,age,gender) VALUES (?,?,?,?,?,?)"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, v.name, -1, nil)
            sqlite3_bind_text(stmt,2, v.name,-1,nil)
            sqlite3_bind_double(stmt, 3, Double(v.weight))
            sqlite3_bind_text(stmt, 4,v.race,-1,nil)
            sqlite3_bind_int(stmt,5,Int32(v.age))
            sqlite3_bind_int(stmt,6, v.gender ? 1:0)
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Inserted a row into vendors")
            } else {
                print("Failed to insert: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Failed to prep: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    private func insertIntoItems(i:Items){
        var stmt:OpaquePointer?
        let query = "INSERT INTO items (name,desc,weight,rarity,category) VALUES (?,?,?,?,?)"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt,1,i.name,-1,nil)
            sqlite3_bind_text(stmt,2,i.desc,-1,nil)
            sqlite3_bind_double(stmt, 3, Double(i.weight))
            sqlite3_bind_int(stmt,4,Int32(i.rarity))
            sqlite3_bind_int(stmt,5,Int32(i.category))
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Inserted a row into items")
            } else {
                print("Failed to insert: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Failed to prep: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    private func insertIntoMyVendors(user_id: Int, vendor_id: Int){
        var stmt:OpaquePointer?
        let query = "INSERT INTO users_vendors (users_id, vendors_id) VALUES (?,?)"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, Int32(user_id))
            sqlite3_bind_int(stmt,2,Int32(vendor_id))
            if sqlite3_step(stmt) == SQLITE_DONE{
                print("Inserted row into users_vendors")
            }else {
                print("Failed to insert: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Failed to prep: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    /*----- READ Methods -----*/
    // All data will be read to the appropriate DBData variable
    private func loadVendors(){
        vendorsDBData.removeAll()
        var stmt: OpaquePointer?
        let query = "SELECT * FROM vendors"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK{
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                let id = Int(sqlite3_column_int(stmt,0))
                let name = String(cString: sqlite3_column_text(stmt, 1))
                let desc = String(cString: sqlite3_column_text(stmt, 2))
                let weight = Float(sqlite3_column_double(stmt, 3))
                let race = String(cString: sqlite3_column_text(stmt, 4))
                let age = Int(sqlite3_column_int(stmt, 5))
                let gender = Bool(sqlite3_column_int(stmt, 6) == 1 ? true : false)
                print("Loading Vendor ID: \(id)...")
                vendorsDBData.append(Vendors(id: id, name: name, desc: desc, weight: weight, race: race, age: age, gender: gender))
            }
        } else {
            print("Failed to prep: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    private func loadItems(){
        itemsDBData.removeAll()
        var stmt: OpaquePointer?
        let query = "SELECT * FROM items"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let id = Int(sqlite3_column_int(stmt,0))
                let name = String(cString: sqlite3_column_text(stmt, 1))
                let desc = String(cString: sqlite3_column_text(stmt, 2))
                let weight = Float(sqlite3_column_double(stmt, 3))
                let rarity = Int(sqlite3_column_int(stmt,4))
                let category = Int(sqlite3_column_int(stmt,5))
                print("Loading Items ID: \(id)")
                itemsDBData.append(Items(id: id, name: name, desc: desc, weight: weight, rarity: rarity, category: category))
            }
        } else {
            print("Failed to prep: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    private func loadMyVendors(){
        myVendorsDBData.removeAll()
        var stmt: OpaquePointer?
        let query = "SELECT vendors_id FROM users_vendors INNER JOIN users ON users.id = \(userID)"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                let id = Int(sqlite3_column_int(stmt,0))
                print("Loading Vendor with ID: \(id)")
                myVendorsDBData.append(vendorsDBData[id])
            }
        } else {
            print("Failed to prep: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    /*------- Load Vendor Inventory -------*/
    private func loadInventory(vendor_id: Int){
        var inventoryList = [Int:Int]()
        var stmt:OpaquePointer?
        let query = "SELECT items_id, quantity FROM inventory INNER JOIN vendors ON vendors.id = inventory.vendors_id"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                let id = Int(sqlite3_column_int(stmt, 0))
                let quantity = Int(sqlite3_column_int(stmt,1))
                print("Loading Item ID: \(id), Quantity: \(quantity)")
                inventoryList[id] = quantity
            }
        } else {
            print("Failed to prep: \(String(cString: sqlite3_errmsg(db)))")
        }
        print("Assigning inventory to vendor \(vendor_id)")
        vendorsDBData[vendor_id-1].inventory = inventoryList
    }
    
}
