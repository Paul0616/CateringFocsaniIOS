//
//  ProfilModel.swift
//  PapaCatering
//
//  Created by Paul Oprea on 04/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class ProfilModel: NSObject {
    //MARK: - Propietati
    
    var selected: Bool
    var nickName: String
    var telefon: String
    
    
    
    //MARK: - Initializare
    
    init?(selected: Bool,
          nickName: String,
          telefon: String
        ) {
        
        //Initaloizeaza proprietatile
        self.selected = selected
        self.nickName = nickName
        self.telefon = telefon
    }
}
