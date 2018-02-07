//
//  AdreseTableViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class AdreseTableViewController: UITableViewController {

    var adrese = [AdresaModel]()
    var restaurant: RestaurantModel!
    var databasePath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let filemgr = FileManager.default
        let dirPath = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        databasePath = dirPath[0].appendingPathComponent("catering.db").path
        /* // DROP TABLE
         if filemgr.fileExists(atPath: databasePath as String) {
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
         
         } */
        
        self.tableView.delaysContentTouches = false
        let cateringDB = FMDatabase(path: databasePath as String)
        
        if (cateringDB.open()){
            let sql_stmt = "CREATE TABLE IF NOT EXISTS ADRESE (ID INTEGER PRIMARY KEY AUTOINCREMENT, IDRESTAURANT INT, ADRESA TEXT, SELECTED INT, LOCATITATE TEXT)"
            if !(cateringDB.executeStatements(sql_stmt)) {
                print("Error: \(cateringDB.lastErrorMessage())")
            }
            cateringDB.close()
        } else {
            print("Error: \(cateringDB.lastErrorMessage())")
        }
        loadDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return adrese.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdreseCell", for: indexPath) as! AdreseTableViewCell
        cell.switchSelected.setOn(adrese[indexPath.row].selected, animated: true)
        cell.switchSelected.tag = indexPath.row
        cell.editBtn.tag = indexPath.row
        cell.delBtn.tag = indexPath.row
        cell.adresaLabel.text = adrese[indexPath.row].adresa + " " + adrese[indexPath.row].localitate
        
        return cell
    }
   
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "test"
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.ultraLight)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "Poti adauga mai multe adrese de livrare si\n selectezi unde vrei sa se faca livrarea"
        label.textAlignment = NSTextAlignment.center
        return label
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    @IBAction func switchAdresaToCurent(_ sender: UISwitch) {
        if sender.isOn {
            for i in 0...(adrese.count-1){
                if i != sender.tag{
                    adrese[i].selected = false
                } else {
                    adrese[i].selected = true
                }
            }
        }
        addToDB(adrese: adrese)
        tableView.reloadData()
    }
    
    @IBAction func edit(_ sender: UIButton) {
    }
    @IBAction func sterge(_ sender: UIButton) {
        if adrese[sender.tag].selected {
            adrese.remove(at: sender.tag)
            if adrese.count > 0 {
                adrese[0].selected = true
            }
        } else {
            adrese.remove(at: sender.tag)
        }
        addToDB(adrese: adrese)
        tableView.reloadData()
    }
    @IBAction func canel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The AdreseTableViewController is not inside a navigation controller.")
        }
    }
    
    
    /*
    // MARK: - Navigation
     */
     @IBAction func unwindToAderseList(sender: UIStoryboardSegue){
        
     if let sourceViewController = sender.source as?
     AdreseModalViewController, let adresa = sourceViewController.adresaModel
     {
     if sourceViewController.index == nil {
     if adrese.count > 0 {
     for i in 0...(adrese.count-1){
     adrese[i].selected = false
     }
     }
     adrese.append(adresa)
     } else {
     let adresaveche = adrese[sourceViewController.index!]
     adresaveche.adresa = adresa.adresa
     adresaveche.localitate = adresa.localitate
     }
     addToDB(adrese: adrese)
     tableView.reloadData()
     
     }
     }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let adresaModalViewController = segue.destination as? AdreseModalViewController
            else{
                fatalError("Unexpected destination: \(segue.destination)")
        }
        
        adresaModalViewController.localitateaText = (restaurant?.locatiiLivrare.components(separatedBy: ","))!
        switch (segue.identifier ?? "") {
        case "EditAdaugaAdrese":
            print("adaugare")
        case "EditAdrese":
            guard let source = sender as? UIButton else {
                fatalError("Unexpeted sender: \(String(describing: sender))")
            }
            
            adresaModalViewController.adresaText = adrese[source.tag].adresa
            adresaModalViewController.localitateAleasa = adrese[source.tag].localitate
            adresaModalViewController.index = source.tag
            print("editare")
        default:
            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
        }
 
    }
 
    //MARK: - Database
    
    private func addToDB(adrese: [AdresaModel]){
        
        let cateringDB = FMDatabase(path: databasePath as String)
        
        if(cateringDB.open()){
            let deleteSql = "DELETE FROM ADRESE WHERE idrestaurant = '\(restaurant.id)'"
            let resultDelete = cateringDB.executeUpdate(deleteSql, withArgumentsIn: [""])
            if !resultDelete {
                print("Error: \(cateringDB.lastErrorMessage())")
            }
            if adrese.count > 0 {
                for i in 0...(adrese.count-1){
                    var selectValue = 0
                    if adrese[i].selected {
                        selectValue = 1
                    }
                    let insertSQL = "INSERT INTO ADRESE (idrestaurant, adresa, selected, locatitate) VALUES ('\(restaurant.id)', '\(adrese[i].adresa)', '\(selectValue)', '\(adrese[i].localitate)')"
                    let result = cateringDB.executeUpdate(insertSQL, withArgumentsIn: [""])
                    if !result {
                        print("Error: \(cateringDB.lastErrorMessage())")
                    }
                }
            }
        } else {
            print("Error: \(cateringDB.lastErrorMessage())")
        }
        cateringDB.close()
    }
    
    
    private func loadDB(){
        let cateringDB = FMDatabase(path: databasePath as String)
        
        if(cateringDB.open()){
            
            let querySQL = "SELECT * FROM ADRESE WHERE idrestaurant = '\(restaurant.id)'"
            
            let results = cateringDB.executeQuery(querySQL, withArgumentsIn: [""])
            
            
            while results?.next() == true {
                let adr = AdresaModel(selected: false, adresa: "", localitate: "")
                adr?.adresa = (results?.string(forColumn: "adresa"))!
                adr?.localitate = (results?.string(forColumn: "locatitate"))!
                if results?.int(forColumn: "selected") == 0 {
                    adr?.selected = false
                } else {
                    adr?.selected = true
                }
                adrese.append(adr!)
            }
        }
        cateringDB.close()
        tableView.reloadData()
    }
}
