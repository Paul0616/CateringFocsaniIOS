//
//  LocatieModel.swift
//  PapaCatering
//
//  Created by Paul Oprea on 04/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class LocatieModel: NSObject {
    //MARK: - Propietati
    
    var denumireLocatie: String
    var linkLocatie: String
    
    //MARK: - Initializare
    
    init?(
        denumireLocatie: String,
        linkLocatie: String
        
        ) {
        
        //Initaloizeaza proprietatile
        
        self.denumireLocatie = denumireLocatie
        self.linkLocatie = linkLocatie
        
    }
}
