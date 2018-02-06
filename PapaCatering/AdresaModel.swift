//
//  AdresaModel.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class AdresaModel: NSObject {
    //MARK: - Propietati
    
    var selected: Bool
    var adresa: String
    var localitate: String
    
    
    
    //MARK: - Initializare
    
    init?(selected: Bool,
          adresa: String,
          localitate: String
        ) {
        
        //Initaloizeaza proprietatile
        self.selected = selected
        self.adresa = adresa
        self.localitate = localitate
    }
}
