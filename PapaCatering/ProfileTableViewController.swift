//
//  ProfileTableViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 04/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    var profile = [ProfilModel]()
    var restaurant: RestaurantModel!
    var databasePath = String()
    
    //MARK: - LOADING class
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.delaysContentTouches = false
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
        
        
        let cateringDB = FMDatabase(path: databasePath as String)
        
        if (cateringDB.open()){
            let sql_stmt = "CREATE TABLE IF NOT EXISTS PROFILE (ID INTEGER PRIMARY KEY AUTOINCREMENT, NICKNAME TEXT, SELECTED INT, TELEFON TEXT)"
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
        return profile.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
        
        cell.switchSelected.setOn(profile[indexPath.row].selected, animated: true)
        cell.switchSelected.tag = indexPath.row
        cell.editBtn.tag = indexPath.row
        cell.delBtn.tag = indexPath.row
        cell.profilLabel.text = profile[indexPath.row].nickName + " " + profile[indexPath.row].telefon
        
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
        label.text = "Poti adauga mai multe profile (de ex. pentru cazul\ncand ai 2 cartele in telefon). Numarul de telefon e obligatoriu"
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

    @IBAction func edit(_ sender: UIButton) {
    }
    
    @IBAction func sterge(_ sender: UIButton) {
        if profile[sender.tag].selected {
            profile.remove(at: sender.tag)
            if profile.count > 0 {
                profile[0].selected = true
            }
        } else {
            profile.remove(at: sender.tag)
        }
        
        
        addToDB(profile: profile)
        tableView.reloadData()
    }
    
    @IBAction func switchCange(_ sender: UISwitch) {
        if sender.isOn {
            for i in 0...(profile.count-1){
                if i != sender.tag{
                    profile[i].selected = false
                } else {
                    profile[i].selected = true
                }
            }
        }
        addToDB(profile: profile)
        tableView.reloadData()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The AProfileTableViewController is not inside a navigation controller.")
        }
    }
    
    // MARK: - Navigation
    @IBAction func unwindToProfileList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as?
            ProfileModalViewController, let profil = sourceViewController.profilModel
        {
            if sourceViewController.index == nil {
                if profile.count > 0 {
                    for i in 0...(profile.count-1){
                        profile[i].selected = false
                    }
                }
                profile.append(profil)
            } else {
                let profilvechi = profile[sourceViewController.index!]
                profilvechi.nickName = profil.nickName
                profilvechi.telefon = profil.telefon
            }
            addToDB(profile: profile)
            tableView.reloadData()
            
        }
    }
   

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        guard let profilModalViewController = segue.destination as? ProfileModalViewController
            else{
                fatalError("Unexpected destination: \(segue.destination)")
        }
        
        // profileModalViewController.localitateaText = (restaurant?.locatiiLivrare.components(separatedBy: ","))!
        switch (segue.identifier ?? "") {
        case "EditAdaugaProfile":
            print("adaugare")
        case "EditProfile":
            guard let source = sender as? UIButton else {
                fatalError("Unexpeted sender: \(String(describing: sender))")
            }
            
            profilModalViewController.numeText = profile[source.tag].nickName
            profilModalViewController.telefonText = profile[source.tag].telefon
            profilModalViewController.index = source.tag
            print("editare")
        default:
            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
        }
    }
   
    
    //MARK: - Database
    
    private func addToDB(profile: [ProfilModel]){
        
        let cateringDB = FMDatabase(path: databasePath as String)
        
        if(cateringDB.open()){
            let deleteSql = "DELETE FROM PROFILE WHERE 1"
            let resultDelete = cateringDB.executeUpdate(deleteSql, withArgumentsIn: [""])
            if !resultDelete {
                print("Error: \(cateringDB.lastErrorMessage())")
            }
            if profile.count > 0 {
                for i in 0...(profile.count-1){
                    var selectValue = 0
                    if profile[i].selected {
                        selectValue = 1
                    }
                    let insertSQL = "INSERT INTO PROFILE (nickname, selected, telefon) VALUES ('\(profile[i].nickName)', '\(selectValue)', '\(profile[i].telefon)')"
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
            
            let querySQL = "SELECT * FROM PROFILE"
            let results = cateringDB.executeQuery(querySQL, withArgumentsIn: [""])
            while results?.next() == true {
                let prof = ProfilModel(selected: false, nickName: "", telefon: "")
                prof?.nickName = (results?.string(forColumn: "nickname"))!
                prof?.telefon = (results?.string(forColumn: "telefon"))!
                if results?.int(forColumn: "selected") == 0 {
                    prof?.selected = false
                } else {
                    prof?.selected = true
                }
                profile.append(prof!)
            }
        }
        cateringDB.close()
        tableView.reloadData()
    }
}
