//
//  AfisareCategoriiCollectionViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

private let reuseIdentifier = "Cell"

class AfisareCategoriiCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var restaurant: RestaurantModel?
    var categorii = [CategorieModel]()
    var nomenclatorCategorii = [CategorieModel]()
    var cosProduse: [ProdusModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.navigationController!.navigationBar.barTintColor = UIColor.darkGray
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: setare imagine fundal
        let backgroundImage = UIImage(named: "bkg_catering_categorii")
        let imageView = UIImageView(image: backgroundImage)
        self.collectionView?.backgroundView = imageView
        self.title = "Categ. meniu " + (restaurant?.denumireRestaurant)!
        
        loadCategorii()
        
    }
    //MARKL: CollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 50
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2, height: (collectionViewSize / 2 - 25))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: -
    func cautaInNomenclator(){
        var nomenclatorDenumire = [String]()
        for i in 0...(nomenclatorCategorii.count-1){
            nomenclatorDenumire.append(nomenclatorCategorii[i].denumireCategorie)
        }
        for i in 0...(categorii.count-1){
            if let idx = nomenclatorDenumire.index(of: categorii[i].denumireCategorie){
                categorii[i].linkPozaCategorie = nomenclatorCategorii[idx].linkPozaCategorie
            }
        }
    }
    
    func loadCategorii(){
        categorii.removeAll()
        self.collectionView?.reloadData()
        let dateconectare: String = (restaurant?.dbname_ip)! + "," + (restaurant?.dbname)! + "," + (restaurant?.passw)!
        let url: String = (restaurant?.ip)! + "/\(WebServerFiles.CATEGORIA)"
        Alamofire.request(url, parameters: ["dateconectare": dateconectare])
            .responseJSON{(responseData) -> Void in
                if((responseData.result.value) != nil){
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    if swiftyJsonVar.count > 0 {
                        for i in 0...(swiftyJsonVar.count - 1){
                            let nume_categorie = swiftyJsonVar[i]["nume_categorie"].stringValue
                            let linkCategorie = "no_photo"
                            guard let categ = CategorieModel(denumireCategorie: nume_categorie, linkPozaCategorie: linkCategorie) else {
                                fatalError("Unable to instantiate CategorieModel")
                            }
                            self.categorii += [categ]
                        }
                        self.nomenclatorCategorii.removeAll()
                        Alamofire.request("http://www.ondesign.ro/getIconuriCategoriiV2.php")
                            .responseJSON{(responseData) -> Void in
                                if((responseData.result.value) != nil){
                                    let swiftyJsonVar1 = JSON(responseData.result.value!)
                                    if swiftyJsonVar1.count > 0 {
                                        for i in 0...(swiftyJsonVar1.count - 1){
                                            guard let categ1 = CategorieModel(denumireCategorie: swiftyJsonVar1[i]["denumire"].stringValue, linkPozaCategorie: swiftyJsonVar1[i]["poza_categorie"].stringValue) else {
                                                fatalError("Unable to instantiate CategorieModel")
                                            }
                                            self.nomenclatorCategorii += [categ1]
                                        }
                                        self.cautaInNomenclator()
                                        
                                        self.collectionView?.reloadData()
                                    }
                                }
                        }
                        
                    }
                }
        }
        
    }
   
    // MARK: - Navigation
 
    @IBAction func unwindFromProduse(segue: UIStoryboardSegue)
    {
        if let sourceViewController = segue.source as?
            ProduseViewController
        {
            cosProduse = sourceViewController.cosProduse
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "Produse":
            guard let produseDestination = segue.destination as? ProduseViewController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            if produseDestination.isViewLoaded {
                print("DA")
            }
            guard let cellSelected = sender as? CategoriiCollectionViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            let categorieSelectata = cellSelected.labelCategorie.text
            produseDestination.restaurant = self.restaurant
            produseDestination.categorieSelectata = categorieSelectata
            var listaCategorii: [String]  = [String]()
            for i in 0...(categorii.count-1){
                listaCategorii.append(categorii[i].denumireCategorie)
            }
            produseDestination.listaCategorii = listaCategorii
            if cosProduse != nil {
                produseDestination.cosProduse = cosProduse
            }
        default:
            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categorii.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorieImgTxt", for: indexPath) as! CategoriiCollectionViewCell
        cell.imageCategorie.af_setImage(withURL: URL(string: categorii[indexPath.row].linkPozaCategorie)!, placeholderImage: UIImage(named: "no_photo"))
        
        cell.labelCategorie.text = categorii[indexPath.row].denumireCategorie
        // Configure the cell
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
