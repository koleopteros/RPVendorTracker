//  Student ID: 100530184
//  DetailsViewController.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    let WIDTH = CGFloat(200.0)
    let HEIGHT = CGFloat(30.0)
    let CATEGORIES:[String] = Items().getCategories()

    var cellId = "itemCell"
    
    // Vars for Passed Data
    var dataInterface: ListInterface?
    var dataStandard: [ListInterface] = [Vendors(), Items()]
    
    var vendorData: Vendors?
    var itemData: Items?
    var dataType = -1
    // No DB implementation yet, so just going to transfer this list of 'existing' items
    var itemsDBData: [Items]?
    var pickerSelection: Items?
    
    var mainStackView: UIStackView = UIStackView()
    var innerStackView: UIStackView = UIStackView()
    var innerLabelStacks: UIStackView = UIStackView()
    var innerTextFieldStacks: UIStackView = UIStackView()
    var innerMidStack: UIStackView = UIStackView()
    var innerDescStack: UIStackView = UIStackView()
    
    var txtViewDescription:UILabel = UILabel()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dataInterface = dataInterface {
            //test for Vendor type
            if type(of:dataInterface) != type(of:dataStandard[0]){
                dataType = 1
                itemData = Items(obj: dataInterface.dataDump())
            } else {
                dataType = 0
                vendorData = Vendors(obj: dataInterface.dataDump())
            }
        }
        print(dataType)
        self.autolayoutMainStackView()
        self.autolayoutStackView()
        self.autolayoutTextViewDescription()
        // Include tableView only if we are adding a new Vendor
        if(dataType==0){
            self.autolayoutInventoryView()
            self.bottomBarButton()
        }
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
    private func bottomBarButton(){
        var button = UIButton(frame: CGRect.init(x: UIScreen.main.bounds.width - 120, y: UIScreen.main.bounds.height - 60, width: 100, height: 40))
        button.setTitle("Add New Inventory", for: UIControlState.normal)
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(DetailsViewController.pickerAlert), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
    }
    /*----- Alert for inventory picker -----*/
    @IBAction func pickerAlert(){
        showPickerAlert(title:"SELECT ITEM", msg:"Pick an item to add\nto this vendor's inventory!")
    }
    private func showPickerAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: UIScreen.main.bounds.width - 30, height: 140))
        pickerFrame.tag = 555
        pickerFrame.delegate = self
        pickerFrame.dataSource = self
        
        alert.view.addSubview(pickerFrame)
        alert.addAction(UIAlertAction(title: "Add!", style: .default, handler: {
            (action) -> Void in
            if self.pickerSelection != nil {
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Nevermind!", style: UIAlertActionStyle.cancel, handler:nil))
        self.present(alert, animated:true, completion:nil)
    }
    /*------ AutoLayouts ------*/
    private func autolayoutMainStackView(){
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant:10).isActive=true
        mainStackView.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant:-10).isActive=true
        mainStackView.topAnchor.constraint(equalTo:view.topAnchor,constant:30).isActive=true
        mainStackView.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-60).isActive=true
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.spacing = 10
    }
    private func autolayoutStackView(){
        mainStackView.addArrangedSubview(innerStackView)
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        innerStackView.axis = .horizontal
        innerStackView.alignment = .fill
        innerStackView.distribution = .fill
        innerStackView.spacing = 10
        
        innerLabelStacks.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.addArrangedSubview(innerLabelStacks)
        innerLabelStacks.sizeToFit()
        innerLabelStacks.axis = .vertical
        innerLabelStacks.alignment = .leading
        innerLabelStacks.distribution = .fillEqually
        innerLabelStacks.spacing = 10
        
        //Setting up Labels for top section
        
        let lblName = UILabel()
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblName.text = "Name"
        innerLabelStacks.addArrangedSubview(lblName)
        let lblDetail1 = UILabel()
        lblDetail1.translatesAutoresizingMaskIntoConstraints = false
        lblDetail1.text = dataType == 0 ? "Age/Sex/Race" : "Rarity/Cat."
        innerLabelStacks.addArrangedSubview(lblDetail1)
        let lblDetail2 = UILabel()
        lblDetail2.translatesAutoresizingMaskIntoConstraints = false
        lblDetail2.text = "Weight"
        innerLabelStacks.addArrangedSubview(lblDetail2)
        
        // MARK: Inserting Text fields
        innerTextFieldStacks.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.addArrangedSubview(innerTextFieldStacks)
        innerTextFieldStacks.axis = .vertical
        innerTextFieldStacks.alignment = .fill
        innerTextFieldStacks.distribution = .equalSpacing
        innerTextFieldStacks.spacing = 0
        
        let txtName = UILabel()
        txtName.translatesAutoresizingMaskIntoConstraints = false
        txtName.text = dataInterface?.getName()
        innerTextFieldStacks.addArrangedSubview(txtName)
        
        innerMidStack.translatesAutoresizingMaskIntoConstraints = false
        innerTextFieldStacks.addArrangedSubview(innerMidStack)
        innerMidStack.axis = .horizontal
        innerMidStack.alignment = .fill
        innerMidStack.distribution = .equalSpacing
        innerMidStack.spacing = 0
        //check if we are dealing with Vendor, else build Item view
        if dataType == 0 {
            let txtAge = UILabel()
            txtAge.translatesAutoresizingMaskIntoConstraints = false
            txtAge.text = String(vendorData!.age)+","
            innerMidStack.addArrangedSubview(txtAge)
            let txtSex = UILabel()
            txtSex.translatesAutoresizingMaskIntoConstraints = false
            txtSex.text = (vendorData!.gender) ? "Male," : "FEMALE,"
            innerMidStack.addArrangedSubview(txtSex)
            let txtRace = UILabel()
            txtRace.translatesAutoresizingMaskIntoConstraints = false
            txtRace.text = vendorData?.race
            innerMidStack.addArrangedSubview(txtRace)
        } else {
            let txtRarity = UILabel()
            txtRarity.translatesAutoresizingMaskIntoConstraints = false
            txtRarity.text = String(itemData!.rarity)+"*"
            innerMidStack.addArrangedSubview(txtRarity)
            let txtCate = UILabel()
            txtCate.translatesAutoresizingMaskIntoConstraints = false
            txtCate.text = CATEGORIES[(itemData?.category)!]
            innerMidStack.addArrangedSubview(txtCate)
        }
        let txtWeight = UILabel()
        txtWeight.translatesAutoresizingMaskIntoConstraints = false
        txtWeight.text = String(dataInterface!.getWeight())+" lbs"
        innerTextFieldStacks.addArrangedSubview(txtWeight)
    }
    private func autolayoutTextViewDescription(){
        innerDescStack.axis = .vertical
        innerDescStack.alignment = .fill
        innerDescStack.distribution = .fillProportionally
        innerDescStack.spacing = 10
        mainStackView.addArrangedSubview(innerDescStack)
        
        let lblDesc = UILabel()
        lblDesc.translatesAutoresizingMaskIntoConstraints = false
        lblDesc.text = "Description:"
        innerDescStack.addArrangedSubview(lblDesc)
        
        innerDescStack.addArrangedSubview(txtViewDescription)
        txtViewDescription.text = dataInterface!.getDesc()
        txtViewDescription.numberOfLines = 15
        txtViewDescription.lineBreakMode = .byWordWrapping
        txtViewDescription.font = txtViewDescription.font?.withSize(14)
        txtViewDescription.backgroundColor = UIColor(red: 220/255, green: 252/255, blue: 209/255, alpha: 1.0)
        txtViewDescription.translatesAutoresizingMaskIntoConstraints = false
    }
    private func autolayoutInventoryView(){
        let lblInventory = UILabel()
        lblInventory.translatesAutoresizingMaskIntoConstraints = false
        lblInventory.text = "Inventory:"
        mainStackView.addArrangedSubview(lblInventory)
        let invTableView: UITableView = UITableView()
        invTableView.register(InventoryItemCell.self, forCellReuseIdentifier: cellId)
        invTableView.delegate = self
        invTableView.dataSource = self
        mainStackView.addArrangedSubview(invTableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for:indexPath) as! InventoryItemCell
        let vendorInvKeys = vendorData?.inventory!.keys.sorted(by: <)
        let currentItem = itemsDBData![vendorInvKeys![indexPath.row]]
        
        cell.item = currentItem
        cell.itemCount = (vendorData?.inventory![vendorInvKeys![indexPath.row]])!
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (vendorData?.inventory?.count)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainStackView.changeBackgroundColor(color: UIColor(red: 244/255, green: 204/255, blue: 195/255, alpha: 1.0))
        innerStackView.changeBackgroundColor(color: UIColor(red: 191/255, green: 235/255, blue: 242/255, alpha: 1.0))
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsDBData!.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemsDBData![row].getName()
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let vendorInvKeys = vendorData?.inventory!.keys.sorted(by: <)
        if (vendorInvKeys?.contains(where: {$0 == itemsDBData![row].id}))!{
            pickerSelection = nil
        }else{
            pickerSelection = itemsDBData?[row]
        }
    }
    
}
