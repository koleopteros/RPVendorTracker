//
//  DetailsViewController.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var dataInterface: ListInterface?
    var dataStandard:[ListInterface]=[]
    
    var nameText: String?
    // MARK: - IBOutlets
    
    // MARK: - View LifeCycle

    override func viewWillAppear(_ animated: Bool){
        //creating empty
        dataStandard.append(Vendors())
        dataStandard.append(Items())
        super.viewWillAppear(animated)
        if let dataInterface = dataInterface {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
