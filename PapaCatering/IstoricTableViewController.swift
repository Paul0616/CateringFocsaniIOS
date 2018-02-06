//
//  IstoricTableViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 06/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class IstoricTableViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var pozitiiIstoric: [IstoricModel] = [IstoricModel]()
    var pozitiiIstoricVizibile: [IstoricModel] = [IstoricModel]()
    var restaurant: RestaurantModel!
    var persoana: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        loadDB()
        let dateconectare: String = (restaurant?.dbname_ip)! + "," + (restaurant?.dbname)! + "," + (restaurant?.passw)!
        let param = ["persoana": persoana, "dateconectare": dateconectare]
        Alamofire.request((restaurant.ip + "/getIstoric1.php"), parameters: param)
            .responseJSON{(responseData) -> Void in
                if((responseData.result.value) != nil){
                    //debugPrint(responseData.debugDescription)
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if swiftyJsonVar.count > 0 {
                        for i in 0...(swiftyJsonVar.count - 1){
                            let poz = IstoricModel(child: false, visible: true, data: "", nrProduse: "", totalGeneral: "", denumire: "", buc: 0, total: "", id: 0)
                            poz!.child = swiftyJsonVar[i]["child"].boolValue
                            if poz!.child {
                                poz!.visible = false
                                poz!.denumire = swiftyJsonVar[i]["denumire"].stringValue
                                poz!.buc = swiftyJsonVar[i]["cantitate"].intValue
                                poz!.total = (swiftyJsonVar[i]["cantitate"].floatValue * swiftyJsonVar[i]["pret"].floatValue).description
                                poz!.id = swiftyJsonVar[i]["id"].intValue
                                
                            } else {
                                poz!.data = swiftyJsonVar[i]["Data"].stringValue
                                poz!.nrProduse = swiftyJsonVar[i]["nrProduse"].stringValue
                                poz!.totalGeneral = swiftyJsonVar[i]["totalGeneral"].stringValue
                                poz!.id = swiftyJsonVar[i]["id"].intValue
                            }
                            self.pozitiiIstoric.append(poz!)
                        }
                    }
                }
                self.setCellsVisible()
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pozitiiIstoricVizibile.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        if pozitiiIstoricVizibile[indexPath.row].child {
            let cellChild = tableView.dequeueReusableCell(withIdentifier: "childCell", for: indexPath) as! IstoricChildTableViewCell
            cellChild.denumireLabel.text = pozitiiIstoricVizibile[indexPath.row].denumire
            cellChild.bucLabel.text = pozitiiIstoricVizibile[indexPath.row].buc.description
            cellChild.totalLabel.text = pozitiiIstoricVizibile[indexPath.row].total + " RON"
            return cellChild
            
        } else {
            let cellParent = tableView.dequeueReusableCell(withIdentifier: "parentCell", for: indexPath) as! IstoricParentTableViewCell
            cellParent.data.text = pozitiiIstoricVizibile[indexPath.row].data
            cellParent.nrProduse.text = pozitiiIstoricVizibile[indexPath.row].nrProduse + " produse"
            cellParent.totalGeneral.text = pozitiiIstoricVizibile[indexPath.row].totalGeneral
            //let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("tapCell")))
            //cellParent.addGestureRecognizer(tapGesture)
            return cellParent
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !pozitiiIstoricVizibile[indexPath.row].child {
            return 80
        } else {
            return 45
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setCellsVisibleAt(id: pozitiiIstoricVizibile[indexPath.row].id)
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "test"
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0.782, green: 0, blue: 0.194, alpha: 1)
        
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "ISTORIC COMENZI\n trimise utilizand profilul tau\n in ultima sapatamana"
        label.textAlignment = NSTextAlignment.center
        return label
    }
    //MARK: - Private
    
    private func setCellsVisibleAt(id: Int){
        pozitiiIstoricVizibile.removeAll()
        for i in 0...(pozitiiIstoric.count - 1){
            if pozitiiIstoric[i].id == id || pozitiiIstoric[i].visible {
                pozitiiIstoricVizibile.append(pozitiiIstoric[i])
            }
        }
        tableView.reloadData()
    }
    
    private func setCellsVisible(){
        if pozitiiIstoric.count > 0 {
            for i in 0...(pozitiiIstoric.count - 1){
                if pozitiiIstoric[i].visible {
                    pozitiiIstoricVizibile.append(pozitiiIstoric[i])
                }
            }
        }
    }
    
   
    private func tapCell(_ sender: UITapGestureRecognizer) {
        
        let point:CGPoint = sender.location(in: tableView)
        print(point.debugDescription)
        let indexPath = tableView.indexPathForRow(at: point)
        print(indexPath!.row)
    }
    
    //MARK: - Database
    private func loadDB(){
        let filemgr = FileManager.default
        let dirPath = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let databasePath = dirPath[0].appendingPathComponent("catering.db").path
        let cateringDB = FMDatabase(path: databasePath as String)
        
        if(cateringDB.open()){
            
            let querySQL = "SELECT * FROM PROFILE"
            let results = cateringDB.executeQuery(querySQL, withArgumentsIn: [""])
            while results?.next() == true {
                persoana += "'" + results!.string(forColumn: "nickname")! + "|" + results!.string(forColumn: "telefon")! + "',"
                
            }
        }
        cateringDB.close()
        if persoana != "" {
            let start = persoana.index(persoana.startIndex, offsetBy: 0)
            let end = persoana.index(persoana.endIndex, offsetBy: -1)
            let range = start..<end
            persoana  = String(persoana[range])
        }
    }

}
