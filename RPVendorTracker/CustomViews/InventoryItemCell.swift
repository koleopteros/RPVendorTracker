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
    var itemCount: Int? {
        didSet {
            if (itemQuantityLabel as UILabel?) != nil {
                itemQuantityLabel.text = String(itemCount as Int!)
            }
        }
    }
    
    private let itemNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let decreaseButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "icons8-minus-32"), for: .normal)
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
        btn.setImage(#imageLiteral(resourceName: "icons8-plus-32"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        
        return btn
    }()
    
    @objc func decreaseQuantity(_ sender: UIButton){
        changeQuantity(by: -1)
    }
    @objc func increaseQuantity(_ sender: UIButton){
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        
        let cellView = UIView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        
        increaseButton.addTarget(self, action: #selector(InventoryItemCell.increaseQuantity), for: UIControlEvents.touchUpInside)
        decreaseButton.addTarget(self, action: #selector(InventoryItemCell.decreaseQuantity), for: UIControlEvents.touchUpInside)
        cellView.addSubview(itemNameLabel)
        cellView.addSubview(increaseButton)
        cellView.addSubview(itemQuantityLabel)
        cellView.addSubview(decreaseButton)
        
        let decreaseConstraint = NSLayoutConstraint(item: decreaseButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: cellView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
        let quantityConstraint = NSLayoutConstraint(item: itemQuantityLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: decreaseButton, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: -10)
        let increaseConstraint = NSLayoutConstraint(item: increaseButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: itemQuantityLabel, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: -10)
        let nameConstraint = NSLayoutConstraint(item: itemNameLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: cellView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 8)
        NSLayoutConstraint.activate([decreaseConstraint,quantityConstraint,increaseConstraint,nameConstraint])
        
        contentView.addSubview(cellView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
