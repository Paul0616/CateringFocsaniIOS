//
//  ProduseViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class ProduseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate  {

    var restaurant: RestaurantModel?
    var categorieSelectata: String?
    var produse = [ProdusModel]()
    var produseFiltrate = [ProdusModel]()
    var totalFloat: Float = 0
    var listaCategorii: [String]?
    var cosProduse: [ProdusModel]!
    
    @IBOutlet weak var categorieCurenta: UILabel!
    @IBOutlet weak var nrProduse: UILabel!
    @IBOutlet weak var ProduseTableView: UITableView!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var collectionIcons: UICollectionView!
     //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        ProduseTableView.dataSource = self
        collectionIcons.dataSource = self
        ProduseTableView.rowHeight = UITableViewAutomaticDimension
        ProduseTableView.estimatedRowHeight = 150
        
        categorieCurenta.text = categorieSelectata
        let dateconectare: String = (restaurant?.dbname_ip)! + "," + (restaurant?.dbname)! + "," + (restaurant?.passw)!
        let url: String = (restaurant?.ip)! + "/getProduse.php"
        Alamofire.request(url, parameters: ["dateconectare": dateconectare])
            .responseJSON{(responseData) -> Void in
                if((responseData.result.value) != nil){
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    if swiftyJsonVar.count > 0 {
                        for i in 0...(swiftyJsonVar.count - 1){
                            let codProdus = swiftyJsonVar[i]["cod"].intValue
                            let denumireProdus = swiftyJsonVar[i]["denumire_produs"].stringValue
                            let descriereProdus = swiftyJsonVar[i]["descriere_produs"].stringValue
                            let pozaProdus = swiftyJsonVar[i]["poza"].stringValue
                            let categorieProdus = swiftyJsonVar[i]["nume_categorie"].stringValue
                            let pretProdus = swiftyJsonVar[i]["pret_bucata"].floatValue
                            guard let produs = ProdusModel(codProdus: codProdus, denumireProdus: denumireProdus, descriereProdus: descriereProdus, categorieProdus: categorieProdus, pozaProdus: pozaProdus, pretProdus: pretProdus, bucati: 0, cerinteSpeciale: "") else {
                                fatalError("Unable to instantiate produs")
                            }
                            self.produse += [produs]
                        }
                        
                        self.loadCosProduse()
                        self.totalComanda()
                        self.filtrare(categorie: self.categorieSelectata!)
                        self.ProduseTableView.reloadData()
                    }
                }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        totalComanda()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        if (self.isMovingFromParentViewController){
            self.performSegue(withIdentifier: "unwindToCat", sender: self)
        }
    }
     //MARK: - Buton plus minus
    
    @IBAction func adaugaProdus(_ sender: Any) {
        guard let selectedPlusBtn = sender as? SemicircularBtn else {
            fatalError("Unexpected sender: \(sender)")
        }
        addBuc(index: selectedPlusBtn.tag)
        
        if cosProduse == nil {
            cosProduse = [ProdusModel]()
        }
        /*---------------
         var saAdaugat: Bool = false
         if cosProduse.count > 0 {
         for i in 0...(cosProduse.count - 1){
         if cosProduse[i].codprodus == produseFiltrate[selectedPlusBtn.tag].codProdus {
         cosProduse[i].bucati = produseFiltrate[selectedPlusBtn.tag].bucati
         saAdaugat = true
         }
         }
         if !saAdaugat {
         let cos = CosProduse.init(codprodus: produseFiltrate[selectedPlusBtn.tag].codProdus, bucati: produseFiltrate[selectedPlusBtn.tag].bucati)
         cosProduse.append(cos!)
         }
         } else {
         let cos = CosProduse.init(codprodus: produseFiltrate[selectedPlusBtn.tag].codProdus, bucati: produseFiltrate[selectedPlusBtn.tag].bucati)
         cosProduse.append(cos!)
         }
         //-----------------*/
        let indexPath = NSIndexPath(row: selectedPlusBtn.tag, section: 0)
        guard let cell = ProduseTableView.cellForRow(at: indexPath as IndexPath) as? ProduseTableViewCell else {
            fatalError("Unexpected error")
        }
        cell.bucatiLabel.text = "x " + produseFiltrate[selectedPlusBtn.tag].bucati.description
        if cell.bucatiLabel.isHidden {
            cell.bucatiLabel.isHidden = false
        }
        totalComanda()
    }
   
    @IBAction func scadeProdus(_ sender: Any) {
        guard let selectedPlusBtn = sender as? SemicircularBtn else {
            fatalError("Unexpected sender: \(sender)")
        }
        subBuc(index: selectedPlusBtn.tag)
        
        if cosProduse == nil {
            cosProduse = [ProdusModel]()
        }
        /*---------------
         var idxDeSters = -1
         if cosProduse.count > 0 {
         for i in 0...(cosProduse.count - 1){
         if cosProduse[i].codprodus == produseFiltrate[selectedPlusBtn.tag].codProdus {
         if produseFiltrate[selectedPlusBtn.tag].bucati == 0 {
         //cosProduse.remove(at: i)
         //continue
         idxDeSters = i
         } else {
         cosProduse[i].bucati = produseFiltrate[selectedPlusBtn.tag].bucati
         }
         }
         }
         if idxDeSters != -1 {
         cosProduse.remove(at: idxDeSters)
         }
         }
         //-----------------*/
        let indexPath = NSIndexPath(row: selectedPlusBtn.tag, section: 0)
        guard let cell = ProduseTableView.cellForRow(at: indexPath as IndexPath) as? ProduseTableViewCell else {
            fatalError("Unexpected error")
        }
        cell.bucatiLabel.text = "x " + produseFiltrate[selectedPlusBtn.tag].bucati.description
        if produseFiltrate[selectedPlusBtn.tag].bucati == 0 {
            cell.bucatiLabel.isHidden = true
        }
        totalComanda()
    }
    
   
    func subBuc(index: Int){
        for i in 0...(produse.count - 1){
            let cod = produseFiltrate[index].codProdus
            if produse[i].codProdus == cod {
                if produse[i].bucati > 0 {
                    produse[i].bucati = produse[i].bucati - 1
                }
            }
        }
    }
    func addBuc(index: Int){
        let cod = produseFiltrate[index].codProdus
        for i in 0...(produse.count - 1){
            if produse[i].codProdus == cod {
                produse[i].bucati = produse[i].bucati + 1
            }
        }
    }
    //MARK: - Invoca cerinte speciale
    @IBAction func invokeModalCerinte(_ sender: Any) {
    }
    
    @IBAction func anuleazaComanda(_ sender: Any) {
        if produse.count > 0 {
            for i in 0...(produse.count - 1){
                if produse[i].bucati > 0 {
                    produse[i].bucati = 0
                }
            }
            ProduseTableView.reloadData()
            totalComanda()
        }
    }
    
    func loadCosProduse(){
        if cosProduse != nil{
            if cosProduse.count > 0 && produse.count > 0 {
                for i in 0...(cosProduse.count - 1){
                    for j in 0...(produse.count - 1){
                        if cosProduse[i].codProdus == produse[j].codProdus{
                            produse[j].bucati = cosProduse[i].bucati
                        }
                    }
                }
            }
        }
    }
    
    func totalComanda(){
        totalFloat = 0
        if cosProduse != nil && produse.count > 0 {
            cosProduse.removeAll()
        }
        if produse.count > 0 {
            for i in 0...(produse.count - 1){
                if produse[i].bucati > 0 {
                    cosProduse.append(produse[i])
                    totalFloat += Float(produse[i].bucati) * produse[i].pretProdus
                }
            }
            ProduseTableView.reloadData()
        }
        if totalFloat != 0 {
            //     self.navigationItem.setHidesBackButton(true, animated: false)
        } else {
            //    self.navigationItem.setHidesBackButton(false, animated: true)
        }
        total.text = "TOTAL: " + totalFloat.description + " RON"
        
    }
    //MARK: - Filtrare dupa categorieProdus
    func filtrare(categorie: String){
        produseFiltrate.removeAll()
        for i in 0...(produse.count - 1){
            if produse[i].categorieProdus == categorie {
                produseFiltrate.append(produse[i])
            }
        }
    }
    
    //MARK: - UICollectionViewDataSource function
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (listaCategorii?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCategorieCollection", for: indexPath) as! IconCategorieCollectionViewCell
        cell.iconImageView.image = UIImage(named: "general")
        cell.labelIcon.text = listaCategorii?[indexPath.row]
        var numeFileIcon = listaCategorii?[indexPath.row].lowercased()
        numeFileIcon = numeFileIcon?.replacingOccurrences(of: " ", with: "_")
        numeFileIcon = numeFileIcon?.replacingOccurrences(of: ".", with: "")
        numeFileIcon = numeFileIcon?.replacingOccurrences(of: "/", with: "_")
        cell.iconImageView.af_setImage(withURL: URL(string: "http://www.ondesign.ro/catering/imagesIconCategorii/" + numeFileIcon! + ".png")!)
        return cell
    }
    //MARK: se apasa icon categorie TREBUIE implementata tapgesture
    
    @IBAction func tapDetected(_ sender: UITapGestureRecognizer) {
        let point:CGPoint = sender.location(in: collectionIcons)
        
        let indexPath = collectionIcons.indexPathForItem(at: point)
        if indexPath != nil {
            let cell = collectionIcons.cellForItem(at: indexPath!) as! IconCategorieCollectionViewCell
            filtrare(categorie: cell.labelIcon.text!)
            ProduseTableView.reloadData()
            categorieCurenta.text = cell.labelIcon.text!
        }
    }
    
    
   //MARK: - UITableViewDataSource functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nrProduse.text = "" + produseFiltrate.count.description + " produse"
        return produseFiltrate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ProduseTableView.dequeueReusableCell(withIdentifier: "ProdusCell", for: indexPath) as? ProduseTableViewCell else {
            fatalError("The dequeued cell is not an instance of ProduseTableViewCell.")
        }
        cell.numeProdus.text = produseFiltrate[indexPath.row].denumireProdus
        cell.descriere.text = produseFiltrate[indexPath.row].descriereProdus
        cell.pret.text = "Pret: " + produseFiltrate[indexPath.row].pretProdus.description + " RON"
        if(produseFiltrate[indexPath.row].cerinteSpeciale != "") {
            cell.cerinteBtn.backgroundColor = UIColor(red: 0.988, green: 0.733, blue: 0.345, alpha: 0.5)
        } else {
            cell.cerinteBtn.backgroundColor = UIColor.white
        }
        cell.plusBtn.tag = indexPath.row
        cell.minusBtn.tag = indexPath.row
        cell.cerinteBtn.tag = indexPath.row
        if produseFiltrate[indexPath.row].bucati > 0 {
            cell.bucatiLabel.isHidden = false
            cell.bucatiLabel.text = "x " + produseFiltrate[indexPath.row].bucati.description
        } else {
            cell.bucatiLabel.isHidden = true
        }
        let url = URL(string: produseFiltrate[indexPath.row].pozaProdus)
        
        if(url != nil){
            cell.pozaProdusImageView.af_setImage(withURL: url!, placeholderImage: UIImage(named: "no_photo"))
        } else {
            cell.pozaProdusImageView.image = UIImage(named: "no_photo")
        }
        
        return cell
        
    }
    // MARK: - Navigation

    @IBAction func unwindFromCerinte(segue: UIStoryboardSegue)
    {
        
        if let sourceViewController = segue.source as?
            CerinteModalViewController, let txt = sourceViewController.cerinteTextField.text
        {
            if sourceViewController.index != nil {
                produseFiltrate[sourceViewController.index!].cerinteSpeciale = txt
                let indexPath = NSIndexPath(row: sourceViewController.index!, section: 0)
                guard let cell = ProduseTableView.cellForRow(at: indexPath as IndexPath) as? ProduseTableViewCell else {
                    fatalError("Unexpected error")
                }
                if(produseFiltrate[indexPath.row].cerinteSpeciale != "") {
                    cell.cerinteBtn.backgroundColor = UIColor(red: 0.988, green: 0.733, blue: 0.345, alpha: 0.5)
                } else {
                    cell.cerinteBtn.backgroundColor = UIColor.white
                }
            }
        }
 
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //let backbutton = UIBarButtonItem()
        //if backbutton == sender.
        switch (segue.identifier ?? "") {
            
        case "editCerinteSpeciale":
            guard let cerinteModalViewController = segue.destination as? CerinteModalViewController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCerinteBtn = sender as? CerinteSpeciale else{
                fatalError("Unexpeted sender: \(String(describing: sender))")
            }
            
            let selectedCerinteText = produseFiltrate[selectedCerinteBtn.tag].cerinteSpeciale
            cerinteModalViewController.index = selectedCerinteBtn.tag
            if selectedCerinteText != "" {
                cerinteModalViewController.cerinteText = selectedCerinteText
            }
        case "confirmaComanda":
            guard let confirmaViewController = segue.destination as? ConfirmaComandaViewController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            var produseComandate = [ProdusModel]()
            for i in 0...(produse.count-1){
                if produse[i].bucati > 0 {
                    produseComandate.append(produse[i])
                }
            }
            confirmaViewController.restaurant = restaurant
            confirmaViewController.produseComandate = produseComandate
        case "unwindToCat":
            print("unwind")
        default:
            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }

    

}
