//
//  RestaurantModel.swift
//  PapaCatering
//
//  Created by Paul Oprea on 03/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class RestaurantModel: NSObject {
    //MARK: - Propietati
    var id: Int
    var denumireRestaurant: String
    var telefon: String
    var linkPoza: String
    var catering: Int
    var rezervari: Int
    var linkLocatia1: String
    var linkLocatia2: String
    var linkLocatia3: String
    var dbname_ip: String
    var dbname: String
    var passw: String
    var ip: String
    var locatiiLivrare: String
    var valoareMinima: Int
    var mesajCatering: String
    var mesajRezervare: String
    var scor: Int
    var start_catering: Date
    var end_catering: Date
    var start_rezervare: String
    var end_rezervare: String
    //MARK: - Initializare
    
    init?(id: Int,
          denumireRestaurant: String,
          telefon: String,
          linkPoza: String,
          catering: Int,
          rezervari: Int,
          linkLocatia1: String,
          linkLocatia2: String,
          linkLocatia3: String,
          dbname_ip: String,
          dbname: String,
          passw: String,
          ip: String,
          locatiiLivrare: String,
          valoareMinima: Int,
          mesajCatering: String,
          mesajRezervare: String,
          scor: Int,
          start_catering: Date,
          end_catering: Date,
          start_rezervare: String,
          end_rezervare: String) {
        
        //Initializeaza proprietatile
        self.id = id
        self.denumireRestaurant = denumireRestaurant
        self.telefon = telefon
        self.linkPoza = linkPoza
        self.catering = catering
        self.rezervari = rezervari
        self.linkLocatia1 = linkLocatia1
        self.linkLocatia2 = linkLocatia2
        self.linkLocatia3 = linkLocatia3
        self.dbname_ip = dbname_ip
        self.dbname = dbname
        self.passw = passw
        self.ip = ip
        self.locatiiLivrare = locatiiLivrare
        self.valoareMinima = valoareMinima
        self.mesajCatering = mesajCatering
        self.mesajRezervare = mesajRezervare
        self.scor = scor
        self.start_catering = start_catering
        self.end_catering = end_catering
        self.start_rezervare = start_rezervare
        self.end_rezervare = end_rezervare
    }
}
