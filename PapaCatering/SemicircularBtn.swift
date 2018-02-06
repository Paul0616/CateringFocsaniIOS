//
//  SemicircularBtn.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

//@IBDesignable
class SemicircularBtn: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
        layer.cornerRadius = 30
        layer.backgroundColor = UIColor.orange.cgColor
        setTitleColor(UIColor.white, for: UIControlState.normal)
        setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
    }

}
