//
//  UIStackView.swift
//  RPVendorTracker
//
//  Created by Jerome Ching on 2019-03-15.
//  Copyright © 2019 Jerome Ching. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func changeBackgroundColor(color:UIColor){
        let backgroundLayer = CAShapeLayer()
        self.layer.insertSublayer(backgroundLayer, at:0)
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = color.cgColor
    }
}
