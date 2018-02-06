//
//  ProdusModel.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class ProdusModel: NSObject {
    //MARK: - Propietati
    
    var codProdus: Int
    var denumireProdus: String
    var descriereProdus: String
    var categorieProdus: String
    var pozaProdus: String
    var pretProdus: Float
    var bucati: Int
    var cerinteSpeciale: String
    
    
    //MARK: - Initializare
    
    init?(codProdus: Int,
          denumireProdus: String,
          descriereProdus: String,
          categorieProdus: String,
          pozaProdus: String,
          pretProdus: Float,
          bucati: Int,
          cerinteSpeciale: String
        ) {
        
        //Initaloizeaza proprietatile
        self.codProdus = codProdus
        self.denumireProdus = denumireProdus
        self.descriereProdus = descriereProdus
        self.categorieProdus = categorieProdus
        self.pozaProdus = pozaProdus
        self.pretProdus = pretProdus
        self.bucati = bucati
        self.cerinteSpeciale = cerinteSpeciale
    }
}
