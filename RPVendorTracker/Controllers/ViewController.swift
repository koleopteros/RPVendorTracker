//  Student ID: 100530184
//  ViewController.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var ListView: UITableView!
    // Dummy data
    var vendorDummyData: [Vendors] = []
    var itemsDummyData: [Items] = []
    var myVendorsDummyData: [Vendors] = []
    var dataInterface: [ListInterface] = []
    
    @IBOutlet weak var addButton: UIButton!
    
    var currentSegment: Int = 0
    
    let segmentNames = ["Vendors","Items","My Vendors"]
    
    override func viewDidLoad() {
        //filling Dummy data, set default list to vendors
        self.fillDummyData()
        dataInterface = vendorDummyData
        super.viewDidLoad()
        
        //setting TableView's delegate and datasource
        ListView.delegate = self
        ListView.dataSource = self
        
        /* Segment control section */
        let segmentCtrl = UISegmentedControl(items:segmentNames)
        segmentCtrl.frame = CGRect(
            x:0,
            y:20,
            width:self.view.frame.width,
            height:30)
        segmentCtrl.addTarget(self,action:
            #selector(ViewController.indexChanged(_:)), for:.valueChanged)
        segmentCtrl.tintColor = UIColor.blue
        segmentCtrl.selectedSegmentIndex = 0
        self.view.addSubview(segmentCtrl)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "mainToDetails" {
            if let indexPath = ListView.indexPathForSelectedRow {
                let destVC = segue.destination as! DetailsViewController
                destVC.dataInterface = self.dataInterface[indexPath.item]
                destVC.itemsDummyData = self.itemsDummyData
            }
        }
        if segue.identifier == "MainToNewObjSegue" {
            let destVC = segue.destination as! FormViewController
            destVC.mode = self.currentSegment
        }
    }
    @objc func indexChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 1:
            currentSegment = 1
            dataInterface = itemsDummyData
            print(segmentNames[1]+" data count: "+String(getDataCount()))
            self.ListView.reloadData()
            updateAddButton()
            break
        case 2:
            currentSegment = 2
            dataInterface = myVendorsDummyData
            print(segmentNames[2]+" data count: "+String(getDataCount()))
            self.ListView.reloadData()
            updateAddButton()
            break
        default:
            currentSegment = 0
            dataInterface = vendorDummyData
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
            return itemsDummyData.count
        case 2:
            return myVendorsDummyData.count
        default:
            return vendorDummyData.count
        }
    }
    
    func updateAddButton(){
        if currentSegment == 2 {
            addButton.titleLabel!.text = "Add New Item"
        }else{
            addButton.titleLabel!.text = "Add New Vendor"
        }
    }
    
    func fillDummyData(){
        //Generating Dummy Data for Vendors
        vendorDummyData.append(Vendors(id:1,name:"Bob Ross",desc:"Master painter and artist",weight:121.5,race:"Human",age:900,gender:true))
        vendorDummyData.append(Vendors(id:2,name:"Jack Daniels",desc:"Whiskey whiskey whiskey",weight:999.5,race:"Human",age:200,gender:true))
        vendorDummyData.append(Vendors(id:3,name:"P Pawluk",desc:"super mobile and agile",weight:148.5,race:"Human",age:35,gender:true))
        vendorDummyData.append(Vendors(id:4,name:"Mike D",desc:"Super edgy and full of stacks",weight:128.5,race:"Human",age:28,gender:true))
        vendorDummyData.append(Vendors(id:5,name:"Mark K",desc:"Neuralmancy specialist",weight:110.8,race:"Human",age:31,gender:true))
        vendorDummyData.append(Vendors(id:6,name:"V Bilijana",desc:"Data Storage specialist",weight:100.8,race:"Human",age:40,gender:false))
        vendorDummyData.append(Vendors(id:6,name:"Anjana S",desc:"Hat and rock specialist",weight:87.8,race:"Human",age:40,gender:false))
        vendorDummyData.append(Vendors(id:7,name:"Kareem A",desc:"Network, Security, and Survival specialist",weight:140.8,race:"Human",age:30,gender:true))

             

        // Generating Dummy data for Items
        itemsDummyData.append(Items(id:1,name:"Bottle of Water", desc:"water in a bottle", weight:1, rarity:1, category:1))
        itemsDummyData.append(Items(id:2,name:"Caltrops", desc:"Very spiky.  Don't touch!", weight:2, rarity:1, category:2))
        itemsDummyData.append(Items(id:3,name:"Mooing steak", desc:"I don't think its ready to eat...", weight:3, rarity:2, category:1))
        itemsDummyData.append(Items(id:4,name:"Bars of Milk Chocolate", desc:"Packed full of sugar and cocoa!", weight:5, rarity:3, category:1))
        itemsDummyData.append(Items(id:5,name:"Short Sword", desc:"Its a sword that is short", weight:1.6, rarity:1, category:3))
        itemsDummyData.append(Items(id:6,name:"Throwing Knives", desc:"Comes in a 5-pack", weight:3, rarity:1, category:2))
        itemsDummyData.append(Items(id:7,name:"Make-up kit thing", desc:"For those who need that Foundation", weight:1, rarity:2, category:2))
        itemsDummyData.append(Items(id:8,name:"Broken iPhone", desc:"Extremely expensive smartphone from some other world.  What's a smartphone you say?  Heck if I know.  Looks fancy and stuff.", weight:2, rarity:5, category:3))
        itemsDummyData.append(Items(id:9,name:"Backpack", desc:"Its a bag.  It holds stuff.  I don't know what else to say...", weight:3, rarity:1, category:2))
        itemsDummyData.append(Items(id:10,name:"Dark Spectacles", desc:"Ever wanted to block out the light? Well these spectacles are for you!  Wear them and deny the sun any place in your eyes.", weight:1, rarity:2, category:3))
        itemsDummyData.append(Items(id:11,name:"Gummy Bears", desc:"gummy bears... very chewy and packed with very little sugar", weight:1, rarity:2, category:1))
        
        // just taking slots 2-5 for "my vendors"
        for i in 2...5{
            myVendorsDummyData.append(vendorDummyData[i])
        }

        // assign random inventory to vendors.  Until Core Data is implemented, this data will constantly change.
        for vendor in vendorDummyData{
            for _ in 0...Int(arc4random_uniform(6)){
                vendor.inventory![Int(arc4random_uniform(UInt32(itemsDummyData.count-1))+1)] = Int(arc4random_uniform(4))+1
            }
        }
    }
}

