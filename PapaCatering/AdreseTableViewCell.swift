//
//  AdreseTableViewCell.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class AdreseTableViewCell: UITableViewCell {

    @IBOutlet weak var switchSelected: UISwitch!
    @IBOutlet weak var adresaLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
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
