//
//  IstoricModel.swift
//  PapaCatering
//
//  Created by Paul Oprea on 06/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class IstoricModel: NSObject {
    //MARK: - Propietati
    
    var child: Bool
    var visible: Bool = true
    var data: String = ""
    var nrProduse: String = ""
    var totalGeneral: String = ""
    var denumire: String = ""
    var buc: Int = 0
    var total: String = ""
    var id: Int
    
    
    
    //MARK: - Initializare
    
    init?(child: Bool,
          visible: Bool,
          data: String,
          nrProduse: String,
          totalGeneral: String,
          denumire: String,
          buc: Int,
          total: String,
          id: Int
        ) {
        
        //Initaloizeaza proprietatile
        self.child = child
        self.visible = visible
        self.data = data
        self.nrProduse = nrProduse
        self.totalGeneral = totalGeneral
        self.denumire = denumire
        self.buc = buc
        self.total = total
        self.id = id
    }
}
