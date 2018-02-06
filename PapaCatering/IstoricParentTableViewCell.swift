//
//  IstoricParentTableViewCell.swift
//  PapaCatering
//
//  Created by Paul Oprea on 06/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class IstoricParentTableViewCell: UITableViewCell {

    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var totalGeneral: UILabel!
    @IBOutlet weak var nrProduse: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
