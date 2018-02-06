//
//  ConfirmaComandaViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ConfirmaComandaViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var adresaLabel: UILabel!
    @IBOutlet weak var profilLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var ConfirmaTableView: UITableView!
    var restaurant: RestaurantModel!
    var produseComandate = [ProdusModel]()
    var jsonString: String!
    
    //MARK: - LOADING
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmaTableView.estimatedRowHeight = 70
        ConfirmaTableView.dataSource = self
        ConfirmaTableView.allowsSelection = false
        ConfirmaTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        calculeazaTotal()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: setare imagine fundal
        let backgroundImage = UIImage(named: "bkg_catering_categorii")
        let imageView = UIImageView(image: backgroundImage)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        adresaLabel.text = ""
        profilLabel.text = ""
        loadIdentificare()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     //MARK: - STERGE COMANDA DIN LISTA
    
    @IBAction func afiseazaAdrese(_ sender: BorderedButton) {
    }
    @IBAction func afiseazaProfile(_ sender: BorderedButton) {
    }
    
    @IBAction func trimite(_ sender: UIBarButtonItem) {
        //VERIFIC DACA SUNT PRODUSE IN LISTA
        if produseComandate.count == 0 {
            showToast(messages: "NU AI ALES NIMIC...", background: UIColor.red)
            return
        }
        //VERIFIC DACA EXISTA DATELE DE INDENTIFICARE SI LIVRARE
        if (adresaLabel.text?.isEmpty)! || (profilLabel.text?.isEmpty)!{
            showToast(messages: "NU poti trimite comanda\n daca nu ai completate\n DATELE DE IDENTIFICARE\n si\n ADRESA DE LIVRARE", background: UIColor.red)
            return
        }
        //VERIFIC VALOAREA MINIMA A COMENZII
        let start = totalLabel.text!.index(totalLabel.text!.startIndex, offsetBy: 7)
        let end = totalLabel.text!.index(totalLabel.text!.endIndex, offsetBy: -4)
        
        
        let totalGeneral = Float(totalLabel.text![start..<end])
        if totalGeneral! < Float(restaurant.valoareMinima) {
            showToast(messages: "Valoare minima a comenzii\n trebuie sa fie de cel putin \(restaurant.valoareMinima) RON.\n Va multumim pentru intelegere!!!", background: UIColor.red)
            return
        }
        //PREGATESC SIRUL JSON PENTRU TRIMITERE
        makeJSON()
        //TRIMIT CU ALAMOFIRE
        let dateconectare: String = (restaurant?.dbname_ip)! + "," + (restaurant?.dbname)! + "," + (restaurant?.passw)!
        let param = ["sirjson": jsonString!, "dateconectare": dateconectare]
        Alamofire.request((restaurant.ip + "/\(WebServerFiles.COMANDA)"), parameters: param)
            .responseJSON{(responseData) -> Void in
                print(responseData.result.isSuccess)
                debugPrint(responseData.response!.statusCode)
        }
        //CRESC SCORUL RESTAURANTULUI
        actualizeazaScorRestaurant()
        //AFISEZ MESAJUL DE SUCCES
       // showToast(messages: restaurant.mesajCatering, background: UIColor.black.withAlphaComponent(0.6))
       let newView = self.storyboard!.instantiateViewController(withIdentifier: "mesajModal") as! MesajModalViewController
        newView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
       newView.restaurant = restaurant
        newView.persoana = profilLabel.text
      self.present(newView, animated: true, completion: nil)
        
    }
    @IBAction func sterge(_ sender: UIButton) {
        //addBuc(index: selectedPlusBtn.tag)
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        produseComandate[indexPath.row].bucati = 0
        produseComandate[indexPath.row].cerinteSpeciale = ""
        produseComandate.remove(at: indexPath.row)
        ConfirmaTableView.reloadData()
        calculeazaTotal()
    }
     //MARK: - FUNCTII butoane ADRESE, PROFILE, TRIMITE
    
    //MARK: - UITableViewDataSource functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return produseComandate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ConfirmaTableView.dequeueReusableCell(withIdentifier: "ElementComandaCell", for: indexPath) as? ConfirmaComandaTableViewCell else {
            fatalError("The dequeued cell is not an instance of ProduseTableViewCell.")
        }
        cell.delBtn.tag = indexPath.row
        
        cell.produsLabel.text = produseComandate[indexPath.row].denumireProdus
        cell.bucatiLabel.text = "x " + produseComandate[indexPath.row].bucati.description
        cell.cerinteLabel.text = produseComandate[indexPath.row].cerinteSpeciale
        var tot: Float = 0
        tot = Float(produseComandate[indexPath.row].pretProdus) * Float(produseComandate[indexPath.row].bucati)
        cell.totalProdusLabel.text = tot.description + " RON"
        return cell
        
    }

    //MARK: - Functii private
    private func makeJSON(){
        var rests = [String]()
        var prods = [String]()
        var bucs = [String]()
        var cods = [String]()
        var prets = [String]()
        var cer = [String]()
        var tots = [String]()
        for i in 0...(produseComandate.count-1){
            rests.append(restaurant.id.description)
            prods.append(produseComandate[i].denumireProdus)
            bucs.append(produseComandate[i].bucati.description)
            cods.append(produseComandate[i].codProdus.description)
            prets.append(produseComandate[i].pretProdus.description)
            cer.append(produseComandate[i].cerinteSpeciale)
            let tot: String = Float(produseComandate[i].pretProdus * Float(produseComandate[i].bucati)).description + " RON"
            tots.append(tot)
        }
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(adresaLabel.text, forKey: "adresa")
        jsonObject.setValue(profilLabel.text, forKey: "persoana")
        jsonObject.setValue(totalLabel.text, forKey: "totalgeneral")
        
        let js: NSMutableDictionary = NSMutableDictionary()
        if produseComandate.count == 1 {
            js.setValue(restaurant.id.description, forKey: "idRestaurant")
            js.setValue(produseComandate[0].denumireProdus, forKey: "produs")
            js.setValue(produseComandate[0].bucati.description, forKey: "bucati")
            js.setValue(produseComandate[0].codProdus.description, forKey: "cod")
            js.setValue(produseComandate[0].pretProdus.description, forKey: "pret")
            js.setValue(produseComandate[0].cerinteSpeciale, forKey: "cerinte_speciale")
            js.setValue((Float(produseComandate[0].pretProdus * Float(produseComandate[0].bucati)).description + " RON"), forKey: "total")
        } else {
            js.setValue(rests, forKey: "idRestaurant")
            js.setValue(prods, forKey: "produs")
            js.setValue(bucs, forKey: "bucati")
            js.setValue(cods, forKey: "cod")
            js.setValue(prets, forKey: "pret")
            js.setValue(cer, forKey: "cerinte_speciale")
            js.setValue(tots, forKey: "total")
        }
        var jss: [NSMutableDictionary] = [NSMutableDictionary]()
        jss.append(jsonObject)
        jss.append(js)
        
        let jsonData: NSData
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jss, options: JSONSerialization.WritingOptions()) as NSData
            jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            
        } catch _ {
            print ("JSON Failure")
        }
    }
    
    private func calculeazaTotal(){
        var totalFloat: Float = 0
        if produseComandate.count > 0 {
            for i in 0...(produseComandate.count - 1){
                if produseComandate[i].bucati > 0 {
                    totalFloat += Float(produseComandate[i].bucati) * produseComandate[i].pretProdus
                }
            }
        }
        totalLabel.text = "TOTAL: " + totalFloat.description + " RON"
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "ConfirmaAdrese":
            guard let adreseNavigation = segue.destination as? UINavigationController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            let adreseDestination = adreseNavigation.viewControllers.first as! AdreseTableViewController
            adreseDestination.restaurant = restaurant
        case "ConfirmaProfile":
            print("hfbsdf")
        default:
            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: - DB scor, identificare
    private func actualizeazaScorRestaurant(){
        let filemgr = FileManager.default
        let dirPath = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let databasePath = dirPath[0].appendingPathComponent("catering.db").path
        let cateringDB = FMDatabase(path: databasePath as String)
        if (cateringDB.open()){
            var querySQL = "SELECT scor FROM RESTAURANTE WHERE idrestaurant = '\(restaurant.id)'"
            let resultsU = cateringDB.executeQuery(querySQL, withArgumentsIn: [""])
            var scornou: Int!
            while resultsU?.next() == true {
                scornou = (resultsU?.long(forColumn: "scor"))! + 1
            }
            querySQL = "UPDATE RESTAURANTE SET scor = '\(scornou!)' WHERE idrestaurant = '\(restaurant.id)'"
            let result = cateringDB.executeUpdate(querySQL, withArgumentsIn: [""])
            if !result {
                print("Error: \(cateringDB.lastErrorMessage())")
            }        }
        cateringDB.close()
    }
    
    private func loadIdentificare(){
        let filemgr = FileManager.default
        let dirPath = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let databasePath = dirPath[0].appendingPathComponent("catering.db").path
        let cateringDB = FMDatabase(path: databasePath as String)
        
        if (cateringDB.open()){
            var querySQL = "SELECT * FROM PROFILE"
            let results = cateringDB.executeQuery(querySQL, withArgumentsIn: [""])
            while results?.next() == true {
                if results?.int(forColumn: "selected") != 0 {
                    profilLabel.text = (results?.string(forColumn: "nickname"))! + "|" + (results?.string(forColumn: "telefon"))!
                }
            }
            querySQL = "SELECT * FROM ADRESE WHERE idrestaurant = '\(restaurant.id)'"
            let resultsA = cateringDB.executeQuery(querySQL, withArgumentsIn: [""])
            while resultsA?.next() == true {
                if resultsA?.int(forColumn: "selected") != 0 {
                    adresaLabel.text = (resultsA?.string(forColumn: "adresa"))! + " " + (resultsA?.string(forColumn: "locatitate"))!
                }
            }
            
        }
        cateringDB.close()
    }
    
    //MARK: - Toast
    func showToast(messages: String, background: UIColor){
        let toastLabel = UILabel(frame: CGRect(x: Int(self.view.frame.size.width/2 - 100), y: 150, width: 200, height: 150))
        toastLabel.backgroundColor = background
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 6
        toastLabel.font = UIFont(name: "", size: 12)
        // toastLabel.adjustsFontSizeToFitWidth = true
        
        toastLabel.text = messages
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    

}
