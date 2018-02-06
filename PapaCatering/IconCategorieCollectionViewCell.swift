//
//  IconCategorieCollectionViewCell.swift
//  PapaCatering
//
//  Created by Paul Oprea on 04/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class IconCategorieCollectionViewCell: UICollectionViewCell {
    //outlet pt. Iconurile din bara de jos produse
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var labelIcon: UILabel!
    
    //outlet pt, imaginile de locatie la revervari
    @IBOutlet weak var imagineLocatie: UIImageView!
    @IBOutlet weak var textLocatie: UILabel!
    
    //outlet pt. iconurile pt. nr. persoane la Rezervari
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func draw(_ rect: CGRect) {
    }
}
