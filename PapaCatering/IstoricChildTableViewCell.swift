//
//  IstoricChildTableViewCell.swift
//  PapaCatering
//
//  Created by Paul Oprea on 06/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class IstoricChildTableViewCell: UITableViewCell {
    @IBOutlet weak var denumireLabel: UILabel!
    @IBOutlet weak var bucLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
