//
//  InventoryItemCell.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-20.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//
import Foundation
import UIKit

protocol InventoryItemDelegate {
    func increaseCount(cell: InventoryItemCell, number: Int)
    func decreaseCount(cell: InventoryItemCell, number: Int)
}

class InventoryItemCell: UITableViewCell {
    var delegate: InventoryItemDelegate?
    var item: Items? {
        didSet{
            itemNameLabel.text = item?.getName()
        }
    }
    var itemCount: Int?
    
    
    private let itemNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let decreaseButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "minusTb"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    
    private let itemQuantityLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let increaseButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "addTb"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    
    @objc func decreaseQuantity(){
        changeQuantity(by: -1)
    }
    @objc func increaseQuantity(){
        changeQuantity(by: 1)
    }
    
    func changeQuantity(by amount: Int){
        var quantity = Int(itemQuantityLabel.text!)!
        quantity += amount
        if quantity < 0 {
            quantity = 0
            itemQuantityLabel.text = "0"
        } else {
            itemQuantityLabel.text = "\(quantity)"
        }
        delegate?.decreaseCount(cell: self, number: quantity)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
