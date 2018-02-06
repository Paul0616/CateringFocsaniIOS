//
//  CategoriiCollectionViewCell.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class CategoriiCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCategorie: UIImageView!
    @IBOutlet weak var labelCategorie: UILabel!
    
    override func draw(_ rect: CGRect) {
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
}
