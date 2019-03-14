//
//  ViewController.swift
//  RPVendorTracker
//
//  Created by user151744 on 3/13/19.
//  Copyright © 2019 user151744. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    let vendorsList = ["Bob Dylan", "Bob Ross", "Candy Dandy", "P. Pawluk", "Mike Denton", "Mark K."]
    let itemsList = ["ball bearings", "Potion","15ft. Rope","Portable Chicken","Shoes","Iron Sword","Magical Hat"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendorsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        myCell.textLabel?.text = vendorsList[indexPath.row]
        return myCell
    }
    
    
    @IBOutlet weak var segmentedCtrl: UISegmentedControl!
    override func viewDidLoad() {
    
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func indexChanged(_ sender: Any) {
    }
    
}

