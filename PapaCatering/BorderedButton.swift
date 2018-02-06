//
//  BorderedButton.swift
//  PapaCatering
//
//  Created by Paul Oprea on 03/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
//@IBDesignable
class BorderedButton: UIButton {

    @IBInspectable
    var borderColor: UIColor = UIColor.darkGray
    @IBInspectable
    var borderWidth: CGFloat = 1
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}
