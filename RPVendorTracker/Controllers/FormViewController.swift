//  Student ID: 100530184
//  FormViewController.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import UIKit

class FormViewController: UIViewController{

    @IBOutlet weak var btnSubmit: UIButton!
    
    // data transferred cause no db implementation... wished i started with that
    var dataType:Int?
    var vendorCount:Int?
    var itemCount:Int?
    
    var mainStack: UIStackView = UIStackView()
    var topStack: UIStackView = UIStackView()
    var labelStack: UIStackView = UIStackView()
    var valueStack: UIStackView = UIStackView()
    var descStack: UIStackView = UIStackView()
    
    //me being lazy
    var vendorAttributes: [String] = ["Age","Gender","Race"]
    var itemAttributes: [String] = ["Category","Rarity"]
    let CATEGORIES = ["Food","Tools","Weapons","Junk"]
    
    // me regretting being lazy
    var txt: [UITextField] = [UITextField]()
    var txtDesc: UITextView?
    
    // temp var to hold new objs
    var newVendor: Vendors?
    var newItem: Items?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // this'll just run all those autolayoutsfunctions
        runErrThang()
        // Do any additional setup after loading the view.
        btnSubmit.addTarget(self, action: #selector(submitClicked(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @IBAction func submitClicked(_ sender: UIButton){
        if dataType == 0{
            runVendorSubmission();
        } else if dataType == 1 {
            runItemSubmission();
        }
    }
    //Order of values... 0,txtDesc,4,3,1,2
    func runVendorSubmission(){
        newVendor = Vendors(id: vendorCount!, name: txt[0].text!, desc: (txtDesc?.text)!, weight: Float(txt[4].text!)!, race: txt[3].text!, age: Int(txt[1].text!)!, gender: txt[2].text! == "Male")
        self.performSegue(withIdentifier: "AddedObjSegue", sender: self)
    }
    func runItemSubmission(){
        newItem = Items(id: itemCount!, name: txt[0].text!, desc: (txtDesc?.text)!, weight: Float(txt[3].text!)!, rarity: Int(txt[2].text!)!, category: CATEGORIES.index(of: txt[1].text!)!)
        self.performSegue(withIdentifier: "AddedObjSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddedObjSegue" {
            let destVC = segue.destination as! ViewController
            if newVendor == nil {
                destVC.newItem = self.newItem
            } else{
                destVC.newVendor = self.newVendor
            }
        }
     }
    private func runErrThang(){
        autolayoutMainStackView()
        autolayoutTopStackView()
        autolayoutLabelStackView()
        autolayoutValueStackView()
        autolayoutDescriptionView()
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
        
        txt.append(UITextField())
        txt[txt.count-1].translatesAutoresizingMaskIntoConstraints = false
        txt[txt.count-1].placeholder = "Name"
        valueStack.addArrangedSubview(txt[txt.count-1])
        
        if dataType == 0 {
            for attr in vendorAttributes {
                txt.append(UITextField())
                txt[txt.count-1].translatesAutoresizingMaskIntoConstraints = false
                txt[txt.count-1].placeholder = attr
                valueStack.addArrangedSubview(txt[txt.count-1])
            }
        } else {
            for attr in itemAttributes {
                txt.append(UITextField())
                txt[txt.count-1].translatesAutoresizingMaskIntoConstraints = false
                txt[txt.count-1].placeholder = attr
                valueStack.addArrangedSubview(txt[txt.count-1])
            }
        }
        txt.append(UITextField())
        txt[txt.count-1].translatesAutoresizingMaskIntoConstraints = false
        txt[txt.count-1].placeholder = "Weight"
        valueStack.addArrangedSubview(txt[txt.count-1])
    }
    private func autolayoutDescriptionView() {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Description:"
        mainStack.addArrangedSubview(lbl)
        
        txtDesc = UITextView()
        txtDesc?.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(txtDesc!)
    }
}
