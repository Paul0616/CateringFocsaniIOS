//
//  ConfirmaComandaTableViewCell.swift
//  PapaCatering
//
//  Created by Paul Oprea on 06/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class ConfirmaComandaTableViewCell: UITableViewCell {
    @IBOutlet weak var produsLabel: UILabel!
    @IBOutlet weak var cerinteLabel: UILabel!
    @IBOutlet weak var bucatiLabel: UILabel!
    @IBOutlet weak var totalProdusLabel: UILabel!
    @IBOutlet weak var delBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
