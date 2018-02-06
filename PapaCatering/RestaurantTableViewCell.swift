//
//  RestaurantTableViewCell.swift
//  PapaCatering
//
//  Created by Paul Oprea on 03/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var pozaRestaurant: UIImageView!
    @IBOutlet weak var denumireRestaurant: UILabel!
    @IBOutlet weak var cateringBtn: BorderedButton!
    @IBOutlet weak var rezervariBtn: BorderedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
