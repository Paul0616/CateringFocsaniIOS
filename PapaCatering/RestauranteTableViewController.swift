//
//  RestauranteTableViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 01/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

import SwiftyJSON
import Alamofire
import AlamofireImage

class RestauranteTableViewController: UITableViewController {
    //MARK: Proprietati
    var restauranteNet = [RestaurantModel]() //array ce contine datele incarcate de pe net
    var databasePath = String()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 170
        //MARK: Create databese if not already exist
        let filemgr = FileManager.default
        let dirPath = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let tabledrop = false
        
        
        databasePath = dirPath[0].appendingPathComponent("catering.db").path
        
        if filemgr.fileExists(atPath: databasePath as String) && tabledrop {
            let cateringDB = FMDatabase(path: databasePath as String)
            if (cateringDB.open()){
                let sql_stmt = "DROP TABLE RESTAURANTE"
                if !(cateringDB.executeStatements(sql_stmt)) {
                    print("Error: \(cateringDB.lastErrorMessage())")
                }
                cateringDB.close()
            } else {
                print("Error: \(cateringDB.lastErrorMessage())")
            }
            
        }
        
        if !filemgr.fileExists(atPath: databasePath as String){
            let cateringDB = FMDatabase(path: databasePath as String)
            
            if (cateringDB.open()){
                let sql_stmt = "CREATE TABLE IF NOT EXISTS RESTAURANTE (ID INTEGER PRIMARY KEY AUTOINCREMENT, IDRESTAURANT INT, DENUMIRE TEXT, LINKPOZA TEXT, CATERING INT, REZERVARI INT, SCOR INT)"
                if !(cateringDB.executeStatements(sql_stmt)) {
                    print("Error: \(cateringDB.lastErrorMessage())")
                }
                cateringDB.close()
            } else {
                print("Error: \(cateringDB.lastErrorMessage())")
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
         //MARK: setare imagine fundal
        let backgroundImage = UIImage(named: "background")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //MARK: setari navigation BAR gradient
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        //gradient
        let gradientLayer = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x:0, y:0, width: sizeLength, height: 64)
        gradientLayer.frame = defaultNavigationBarFrame
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x:0.5, y:0.1)
        gradientLayer.endPoint = CGPoint(x:0.5, y:1)
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
       
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        loadData()
    }
    
    //MARK: - Incarca de pe net lista cu restaurante si o salveaza in vectorul restaurantNet
    func loadData(){
        restauranteNet.removeAll()
        self.tableView.reloadData()
        Alamofire.request(WebServerFiles.WEB_LISTA_RESTAURANTE)
            .responseJSON{(responseData) -> Void in
                if((responseData.result.value) != nil){
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    if swiftyJsonVar.count > 0 {
                        for i in 0...(swiftyJsonVar.count - 1){
                            let id = swiftyJsonVar[i]["id"].intValue
                            let denumire = swiftyJsonVar[i]["denumire"].stringValue
                            let catering = swiftyJsonVar[i]["catering"].intValue
                            let rezervari = swiftyJsonVar[i]["rezervari"].intValue
                            let linkPoza = swiftyJsonVar[i]["poza"].stringValue
                            let telefon = swiftyJsonVar[i]["telefon"].stringValue
                            let link1 = swiftyJsonVar[i]["Locatia1"].stringValue
                            let link2 = swiftyJsonVar[i]["Locatia2"].stringValue
                            let link3 = swiftyJsonVar[i]["Locatia3"].stringValue
                            let dbname_ip = swiftyJsonVar[i]["dbname_ip"].stringValue
                            let dbname = swiftyJsonVar[i]["dbname"].stringValue
                            let pass = swiftyJsonVar[i]["passw"].stringValue
                            let ip = swiftyJsonVar[i]["ip"].stringValue
                            let locatiilivrare = swiftyJsonVar[i]["locatii_livrare"].stringValue
                            let valoare = swiftyJsonVar[i]["valoare_minima"].intValue
                            let mesajcatering = swiftyJsonVar[i]["mesaj_catering"].stringValue
                            let mesajrezervare = swiftyJsonVar[i]["mesaj_rezervare"].stringValue
                            let start_cateringS = swiftyJsonVar[i]["start_catering"].stringValue
                            let end_cateringS = swiftyJsonVar[i]["end_catering"].stringValue
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "ro_RO")
                            dateFormatter.dateFormat = "HH:mm:ss"
                            let start_catering = dateFormatter.date(from: start_cateringS)
                            let end_catering = dateFormatter.date(from: end_cateringS)
                            let start_rezervare = swiftyJsonVar[i]["start_rezervari"].stringValue
                            let end_rezervare = swiftyJsonVar[i]["end_rezervari"].stringValue
                            guard let restaurant = RestaurantModel(id: id, denumireRestaurant: denumire, telefon: telefon, linkPoza: linkPoza, catering: catering, rezervari: rezervari, linkLocatia1: link1, linkLocatia2: link2, linkLocatia3: link3, dbname_ip: dbname_ip, dbname: dbname, passw: pass, ip: ip, locatiiLivrare: locatiilivrare, valoareMinima: valoare, mesajCatering: mesajcatering, mesajRezervare: mesajrezervare, scor: 0, start_catering: start_catering!, end_catering: end_catering!, start_rezervare: start_rezervare, end_rezervare: end_rezervare) else {
                                fatalError("Unable to instantiate restaurant1")
                            }
                            self.restauranteNet += [restaurant]
                        }
                    }
                }
                self.saveNewRestaurantsToDB(restaurante: self.restauranteNet)
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
        }
    }
    
    //MARK: - Adauga Restaurant in DB
    func addRestaurantToDB(restaurant: RestaurantModel, database: FMDatabase){
        
        if(database.open()){
            //y += 1
            let insertSQL = "INSERT INTO RESTAURANTE (idrestaurant, denumire, linkpoza, catering, rezervari, scor) VALUES (\(restaurant.id), '\(sanitizationString(stringToModify: restaurant.denumireRestaurant))', '\(restaurant.linkPoza)', \(restaurant.catering), \(restaurant.rezervari), 0)"
            let result = database.executeUpdate(insertSQL, withArgumentsIn: [""])
            if !result {
                print("Error: \(database.lastErrorMessage())")
            }
        } else {
            print("Error: \(database.lastErrorMessage())")
        }
    }
    
    func sanitizationString(stringToModify: String) -> String{
        let replacements = ["'": "''", "\"": "\""]
        var str = stringToModify
        replacements.keys.forEach {str = str.replacingOccurrences(of: $0, with: replacements[$0]!) }
        return str
    }
    //MARK: Sterge Restaurant din DB
    func removeRestaurantToDB(idRestaurant: Int, database: FMDatabase){
        
        if(database.open()){
            let deleteSQL = "DELETE FROM RESTAURANTE WHERE idrestaurant = \(idRestaurant)"
            let result = database.executeUpdate(deleteSQL, withArgumentsIn: [""])
            if !result {
                print("Error: \(database.lastErrorMessage())")
            }
        } else {
            print("Error: \(database.lastErrorMessage())")
        }
    }
    
    //MARK: Sincronizeaza DB cu ce se incarca de pe net
    func saveNewRestaurantsToDB(restaurante: [RestaurantModel]){
        if restaurante.count == 0 {
            showToast(messages: ["Nici un restaurant gasit.", "Probabil lipsa acces INTERNET..."], preambul: false)
            return //posibil sa nu existe acces internet
        }
        let cateringDB = FMDatabase(path: databasePath as String)
        var numeRestauranteNoi: [String] = [String]()
        if(cateringDB.open()){
            var idsDB = [Int]()
            var idsNET = [Int]()
            
            var querySQL = "SELECT idrestaurant FROM RESTAURANTE"
          
            let resultsWithoutScor = cateringDB.executeQuery(querySQL, withArgumentsIn: [""])
            while resultsWithoutScor?.next() == true {
                idsDB.append((resultsWithoutScor?.long(forColumn: "idrestaurant"))!)
            }
            if restaurante.count > 0 {
                for i in 0...(restaurante.count - 1){
                    if !idsDB.contains(restaurante[i].id){
                        addRestaurantToDB(restaurant: restaurante[i], database: cateringDB)
                        numeRestauranteNoi += ["\n" + restaurante[i].denumireRestaurant]
                    }
                    idsNET.append(restaurante[i].id)
                }
            }
            if idsDB.count > 0 {
                for i in 0...(idsDB.count - 1){
                    if !idsNET.contains(idsDB[i]){
                        removeRestaurantToDB(idRestaurant: idsDB[i], database: cateringDB)
                    }
                }
            }
           
            
            
            querySQL = "SELECT idrestaurant, scor FROM RESTAURANTE"
            let resultsWithScor = cateringDB.executeQuery(querySQL, withArgumentsIn: [""])
            while resultsWithScor?.next() == true{
                for restaurant in restauranteNet{
                    guard let id = resultsWithScor?.long(forColumn: "idrestaurant") else {
                        return
                    }
                    guard let scor = resultsWithScor?.long(forColumn: "scor") else {
                        return
                    }
                    if restaurant.id == id {
                        restaurant.scor = scor
                    }
                }
            }
            
            restauranteNet = restauranteNet.sorted {($0.scor as Int) > ($1.scor as Int)}
            cateringDB.close()
        }
        if numeRestauranteNoi.count > 0 {
            showToast(messages: numeRestauranteNoi, preambul: true)
        }
       
    }
    //MARK: -  Toast
    func showToast(messages: [String], preambul: Bool){
        var msg: String = ""
        let toastLabel = UILabel(frame: CGRect(x: Int(self.view.frame.size.width/2 - 100), y: 30, width: 200, height: Int(35 + (messages.count * 35))))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = messages.count + 1
        toastLabel.font = UIFont(name: "", size: 12)
        toastLabel.adjustsFontSizeToFitWidth = true
        if preambul {
            msg = "Acum poti comanda si de la: "
        }
        for i in 0...(messages.count-1) {
            msg += messages[i]
        }
        toastLabel.text = msg
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
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return restauranteNet.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.allowsSelection = false
        guard let firstCell = tableView.dequeueReusableCell(withIdentifier: "UndeMancamTableViewCell", for: indexPath) as? UndeMancamTableViewCell else {
            fatalError("The dequeued cell is not an instance of UndeMancamTableViewCell.")
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as? RestaurantTableViewCell else {
            fatalError("The dequeued cell is not an instance of RestaurantTableViewCell.")
        }
        cell.cateringBtn.tag = indexPath.row
        cell.rezervariBtn.tag = indexPath.row
        cell.backgroundColor = .clear
        firstCell.backgroundColor = .clear
        firstCell.undeMancamLabel.textColor = UIColor.white
       
        if restauranteNet.count != 0{
           let restaurant = restauranteNet[indexPath.row]
            
           // let placeholderImage = UIImage(named: "noavailable")
           // let uslString = String(restaurant.linkPoza)
           // let url = URLConvertible.asURL(restaurant.linkPoza)
            cell.pozaRestaurant.af_setImage(withURL: URL(string: restaurant.linkPoza)!)
            //let downloader = ImageDownloader()
           // let urlRequest = URLRequest(url: URL(string: restaurant.linkPoza)!)
           // downloader.download(urlRequest){response in
          //      print(response.request)
          //      print(response.response)
          //      debugPrint(response.result)
          //      if let image = response.result.value{
         //           print(image)
         //       }
        //    }
          
           //  cell.pozaRestaurant.af_imageDownloader?.download(url as! URLRequestConvertible, completion: <#T##ImageDownloader.CompletionHandler?##ImageDownloader.CompletionHandler?##(DataResponse<Image>) -> Void#>)
            //                                                 completion:{(response)
          //      print("image: \(cell.pozaRestaurant.image)")
         //       print(response.result.value) //# UIImage
         //       print(response.result.error) //# NSError
         //       })
           
            
           
            cell.denumireRestaurant.text = restaurant.denumireRestaurant
            
            if restaurant.catering != 0 {
                cell.cateringBtn.isHidden = false
            } else {
                cell.cateringBtn.isHidden = true
            }
            if restaurant.rezervari != 0 {
                cell.rezervariBtn.isHidden = false
            } else {
                cell.rezervariBtn.isHidden = true
            }
        }
 
        
        // Configure the cell...
        if indexPath.section == 0 {
            return firstCell
        } else {
            return cell
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
 
    @IBAction func unwindToStart(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as?
            MesajRezervareViewController
        {
           
        }
    }
    */
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "Catering":
            guard let cateringDestination = segue.destination as? IntroRestaurantViewController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCateringBtn = sender as? BorderedButton else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            let selectedRestaurant = restauranteNet[selectedCateringBtn.tag]
            cateringDestination.restaurant = selectedRestaurant
        case "Rezervari":
            guard let rezervariDestination = segue.destination as? RezervariViewController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedRezervariBtn = sender as? BorderedButton else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            let selectedRestaurant = restauranteNet[selectedRezervariBtn.tag]
            rezervariDestination.restaurant = selectedRestaurant
        default:
            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
        }
     }
 
}

