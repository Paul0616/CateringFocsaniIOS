//
//  CategorieModel.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class CategorieModel: NSObject {
    //MARK: - Propietati
    
    var denumireCategorie: String
    var linkPozaCategorie: String
    
    //MARK: - Initializare
    
    init?(
        denumireCategorie: String,
        linkPozaCategorie: String) {
        
        //Initaloizeaza proprietatile
        self.linkPozaCategorie = linkPozaCategorie
        self.denumireCategorie = denumireCategorie
    }
}
