//
//  CustomListCell.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation
import UIKit

class CustomListCell: UITableViewCell{
    var name: String?
    var detail: String?
    
    var nameView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var detailView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?){
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        self.addSubview(nameView)
        self.addSubview(detailView)
        
        nameView.leftAnchor.constraint(equalTo:self.leftAnchor).isActive=true
        nameView.rightAnchor.constraint(equalTo:self.rightAnchor).isActive=true
        nameView.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive=true
        nameView.topAnchor.constraint(equalTo:self.topAnchor).isActive=true
        
        detailView.leftAnchor.constraint(equalTo:self.nameView.rightAnchor).isActive=true
        detailView.rightAnchor.constraint(equalTo:self.rightAnchor).isActive=true
        detailView.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive=true
        detailView.topAnchor.constraint(equalTo:self.topAnchor).isActive=true
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        if let name = name{
            nameView.text = name
        }
        if let detail = detail{
            detailView.text = detail
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
