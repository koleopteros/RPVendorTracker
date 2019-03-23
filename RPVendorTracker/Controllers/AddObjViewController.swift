//
//  AddObjViewController.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-21.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import UIKit

class AddObjViewController: UIViewController {
    // data received from other views
    var dataType:Int?
    
    var mainStack: UIStackView = UIStackView()
    
    var topStack: UIStackView = UIStackView()
    var labelStack: UIStackView = UIStackView()
    var valueStack: UIStackView = UIStackView()
    var descStack: UIStackView = UIStackView()
    
    //me being lazy
    var vendorAttributes: [String] = ["Age","Gender","Race"]
    var itemAttributes: [String] = ["Category","Rarity"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // this'll just run all those autolayoutsfunctions
        runErrThang()
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
    private func runErrThang(){
        autolayoutMainStackView()
        autolayoutTopStackView()
        autolayoutLabelStackView()
        autolayoutValueStackView()
    }
    private func autolayoutMainStackView() {
        view.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.leadingAnchor.constraint(equalTo:view.leadingAnchor,constant:10).isActive = true
        mainStack.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant:-10).isActive = true
        mainStack.topAnchor.constraint(equalTo:view.topAnchor,constant:30).isActive = true
        mainStack.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant:-60).isActive = true
        
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        mainStack.spacing = 10
    }
    private func autolayoutTopStackView() {
        mainStack.addArrangedSubview(topStack)
        topStack.translatesAutoresizingMaskIntoConstraints = false
        
        topStack.axis = .horizontal
        topStack.alignment = .fill
        topStack.distribution = .fill
        topStack.spacing = 10
        
    }
    private func autolayoutLabelStackView() {
        topStack.addArrangedSubview(labelStack)
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        labelStack.sizeToFit()
        labelStack.axis = .vertical
        labelStack.alignment = .fill
        labelStack.distribution = .fill
        labelStack.spacing = 10
        
        // Load in labels lazy way
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Name"
        labelStack.addArrangedSubview(lbl)
        
        if dataType == 0 {
            for attr in vendorAttributes {
                lbl = UILabel()
                lbl.translatesAutoresizingMaskIntoConstraints = false
                lbl.text = attr
                labelStack.addArrangedSubview(lbl)
            }
        } else {
            for attr in itemAttributes {
                lbl = UILabel()
                lbl.translatesAutoresizingMaskIntoConstraints = false
                lbl.text = attr
                labelStack.addArrangedSubview(lbl)
            }
        }
        lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Weight"
        labelStack.addArrangedSubview(lbl)
    }
    private func autolayoutValueStackView(){
        topStack.addArrangedSubview(valueStack)
        valueStack.translatesAutoresizingMaskIntoConstraints = false
        
        valueStack.sizeToFit()
        valueStack.axis = .vertical
        valueStack.alignment = .fill
        valueStack.distribution = .fill
        valueStack.spacing = 10
        
        var txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Name"
        if dataType == 0 {
            for attr in vendorAttributes {
                txt = UITextField()
                txt.translatesAutoresizingMaskIntoConstraints = false
                txt.placeholder = attr
                valueStack.addArrangedSubview(txt)
            }
        } else {
            for attr in vendorAttributes {
                txt = UITextField()
                txt.translatesAutoresizingMaskIntoConstraints = false
                txt.placeholder = attr
                valueStack.addArrangedSubview(txt)
            }
        }
    }
}
