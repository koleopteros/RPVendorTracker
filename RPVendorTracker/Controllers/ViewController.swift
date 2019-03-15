//
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
    
    var currentSegment: Int = 0
    
    let segmentNames = ["Vendors","Items","My Vendors"]
    let addNewButton: UIButton = {
        let button = UIButton(frame:CGRect.init(
            x:UIScreen.main.bounds.width*0.2,
            y:UIScreen.main.bounds.height-55,
            width:UIScreen.main.bounds.width*0.6,
            height:CGFloat(45)
        ))
        button.backgroundColor=UIColor.lightGray
        button.setTitle("Add", for: UIControlState.normal)
        
        return button
    }()
    override func viewDidLoad() {
        //filling Dummy data, set default list to vendors
        self.fillDummyData()
        dataInterface = vendorDummyData
        super.viewDidLoad()
        
        //setting TableView's delegate and datasource
        ListView.delegate = self
        ListView.dataSource = self
        
        //create Add Button
        self.view.addSubview(addNewButton)
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
            }
        }
    }
    @objc func indexChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 1:
            currentSegment = 1
            dataInterface = itemsDummyData
            print(segmentNames[1]+" data count: "+String(getDataCount()))
            self.ListView.reloadData()
            print()
            break
        case 2:
            currentSegment = 2
            dataInterface = myVendorsDummyData
            print(segmentNames[2]+" data count: "+String(getDataCount()))
            self.ListView.reloadData()
            break
        default:
            currentSegment = 0
            dataInterface = vendorDummyData
            print(segmentNames[0]+" data count: "+String(getDataCount()))
            self.ListView.reloadData()
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
        print("Data-type check: \n\tCurrent Segment: \(segmentNames[currentSegment]) \n\tActual Segment: \(type(of:type(of:dataInterface[0])))")
        print("Attempting to fill indexpath #\(indexPath.item)")
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
    
    func fillDummyData(){
        vendorDummyData.append(Vendors(id:1,name:"Bob Ross",desc:"Master painter and artist",weight:121.5,race:"Human",age:900,gender:true))
        vendorDummyData.append(Vendors(id:2,name:"Jack Daniels",desc:"Whiskey whiskey whiskey",weight:999.5,race:"Human",age:900,gender:true))
        vendorDummyData.append(Vendors(id:3,name:"P Pawluk",desc:"super mobile and agile",weight:148.5,race:"Human",age:900,gender:true))
        vendorDummyData.append(Vendors(id:4,name:"Mike D",desc:"Super edgy and full of stacks",weight:128.5,race:"Human",age:900,gender:true))
        vendorDummyData.append(Vendors(id:5,name:"Mark K",desc:"Neuralmancy specialist",weight:110.8,race:"Human",age:900,gender:true))
        vendorDummyData.append(Vendors(id:6,name:"V Bilijana",desc:"Data Storage specialist",weight:100.8,race:"Human",age:900,gender:false))
        
        itemsDummyData.append(Items(id:1,name:"Bottle of Water", desc:"water in a bottle", weight:1, rarity:1, category:1))
        itemsDummyData.append(Items(id:2,name:"Caltrops", desc:"Very spiky.  Don't touch!", weight:2, rarity:1, category:2))
        itemsDummyData.append(Items(id:3,name:"Mooing steak", desc:"I don't think its ready to eat...", weight:3, rarity:2, category:1))
        itemsDummyData.append(Items(id:4,name:"Bars of Milk Chocolate", desc:"Packed full of sugar and cocoa!", weight:5, rarity:3, category:1))
        itemsDummyData.append(Items(id:5,name:"Short Sword", desc:"Its a sword that is short", weight:1.6, rarity:1, category:3))
        itemsDummyData.append(Items(id:6,name:"Throwing Knives", desc:"Comes in a 5-pack", weight:3, rarity:1, category:2))
        itemsDummyData.append(Items(id:7,name:"Make-up kit thing", desc:"For those who need that Foundation", weight:1, rarity:2, category:2))
        
        for i in 2...5{
            myVendorsDummyData.append(vendorDummyData[i])
        }
    }
}

