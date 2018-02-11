//
//  ConfirmaRezervareaViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 04/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Alamofire

class ConfirmaRezervareaViewController: UIViewController {

    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var persoanaLabel: UILabel!
    @IBOutlet weak var locatieLabel: UILabel!
    @IBOutlet weak var dataRezervarii: UILabel!
    @IBOutlet weak var nrpersoaneLabel: UILabel!
    @IBOutlet weak var trimiteBtn: UIButton!
    var locatie: String!
    var datarez:String!
    var nrpers: Int!
    var restaurant: RestaurantModel!
    var jsonString: String!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        locatieLabel.text = "Locatia: " + locatie
        nrpersoaneLabel.text = "Numar de persoane: " + nrpers.description
        restaurantLabel.text = restaurant.denumireRestaurant
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        let date = dateFormatter.date(from: datarez)
        dateFormatter.locale = Locale(identifier: "ro_RO")
        dateFormatter.dateFormat = "EEEE, dd MMM YYY, HH:mm"
        dataRezervarii.text = dateFormatter.string(from: date!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if !loadIdentificare() {
            persoanaLabel.text = "trebuie sa alegi o persoana de contact"
            persoanaLabel.textColor = UIColor.red
            trimiteBtn.isEnabled = false
        } else {
            persoanaLabel.textColor = UIColor.black
            trimiteBtn.isEnabled = true
        }
    }

    @IBAction func schimbaButon(_ sender: BorderedButton) {
        
    }
    @IBAction func trimiteRezervarea(_ sender: Any) {
        //VERIFICA DACA E IN INTERVALUL DE REZERVARI
        
        
        actualizeazaScorRestaurant()
        makeJSON()
        let dateconectare: String = (restaurant?.dbname_ip)! + "," + (restaurant?.dbname)! + "," + (restaurant?.passw)!
        let param = ["sirjson": jsonString!, "dateconectare": dateconectare]
        Alamofire.request((restaurant.ip + "/\(WebServerFiles.REZERVAREA)"), parameters: param)
            .responseJSON{(responseData) -> Void in
                //print(responseData.result.isSuccess)
                debugPrint(responseData.response!.statusCode)
                if responseData.response!.statusCode == 200 {
                    let newView = self.storyboard!.instantiateViewController(withIdentifier: "mesajRezervareModal") as! MesajRezervareViewController
                    newView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    newView.restaurant = self.restaurant
                    self.present(newView, animated: true, completion: nil)
                }
                // debugPrint(responseData.debugDescription)
                
        }
        
        //showToast(messages: restaurant.mesajRezervare, background: UIColor.black.withAlphaComponent(0.6))
        
    }
    
    //MARK: - DB scor, identificare
    private func actualizeazaScorRestaurant(){
        let filemgr = FileManager.default
        let dirPath = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let databasePath = dirPath[0].appendingPathComponent("catering.db").path
        let cateringDB = FMDatabase(path: databasePath as String)
        if (cateringDB.open()){
            var querySQL = "SELECT scor FROM RESTAURANTE WHERE idrestaurant = '\(restaurant.id)'"
            let results = cateringDB.executeQuery(querySQL, withArgumentsIn: [""])
            var scornou: Int!
            while results?.next() == true {
                scornou = (results?.long(forColumn: "scor"))! + 1
            }
            querySQL = "UPDATE RESTAURANTE SET scor = '\(scornou!)' WHERE idrestaurant = '\(restaurant.id)'"
            let result = cateringDB.executeUpdate(querySQL, withArgumentsIn: [""])
            if !result {
                print("Error: \(cateringDB.lastErrorMessage())")
            }        }
        cateringDB.close()
    }
    
    private func loadIdentificare() -> Bool {
        let filemgr = FileManager.default
        let dirPath = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let databasePath = dirPath[0].appendingPathComponent("catering.db").path
        let cateringDB = FMDatabase(path: databasePath as String)
        
        if (cateringDB.open()){
            let q = "SELECT COUNT(*) as Count FROM PROFILE"
            if let resultsCount = cateringDB.executeQuery(q, withArgumentsIn: [""]) {
                while resultsCount.next() == true {
                    if resultsCount.int(forColumn: "Count") == 0 {
                        return false
                    }
                }
            } else {
                return false
            }
            let querySQL = "SELECT * FROM PROFILE"
            let results = cateringDB.executeQuery(querySQL, withArgumentsIn: [""])
                while results!.next() == true {
                    if results!.int(forColumn: "selected") != 0 {
                        persoanaLabel.text = (results!.string(forColumn: "nickname"))! + "|" + (results!.string(forColumn: "telefon"))!
                    }
                }
        }
        cateringDB.close()
        return true
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
    
    //MARK: - Functii private
    private func makeJSON(){
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(persoanaLabel.text, forKey: "persoana")
        jsonObject.setValue(locatie, forKey: "locatie")
        jsonObject.setValue(datarez, forKey: "dataRezervarii")
        jsonObject.setValue(nrpers.description, forKey: "nrpersoane")
        jsonObject.setValue(restaurant.id.description, forKey: "idRestaurant")
        
        var jss: [NSMutableDictionary] = [NSMutableDictionary]()
        jss.append(jsonObject)
        
        
        let jsonData: NSData
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jss, options: JSONSerialization.WritingOptions()) as NSData
            jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            
        } catch _ {
            print ("JSON Failure")
        }
    }
    /*
    // MARK: - Navigation
     */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "schimbaProfil":
            guard let profileNavigation = segue.destination as? UINavigationController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            let profileDestination = profileNavigation.viewControllers.first as! ProfileTableViewController
            profileDestination.restaurant = restaurant
       
        default:
            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

}
