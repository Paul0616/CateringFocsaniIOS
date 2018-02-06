//
//  ProduseTableViewCell.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class ProduseTableViewCell: UITableViewCell {

   
    @IBOutlet weak var plusBtn: SemicircularBtn!
    @IBOutlet weak var minusBtn: SemicircularBtn!
    @IBOutlet weak var cerinteBtn: CerinteSpeciale!
    @IBOutlet weak var bucatiLabel: UILabel!
    @IBOutlet weak var pozaProdusImageView: UIImageView!
    @IBOutlet weak var pret: UILabel!
    @IBOutlet weak var descriere: UILabel!
    @IBOutlet weak var numeProdus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
