//
//  RezervariViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 04/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class RezervariViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nrPersoaneCollection: UICollectionView!
    @IBOutlet weak var confirmaBtn: UIButton!
    @IBOutlet weak var pozeLocatii: UICollectionView!
    
    @IBOutlet weak var locatieSelectata: UILabel!
    @IBOutlet weak var nrpersoane: UILabel!
    @IBOutlet weak var datarezervarii: UILabel!
    let persWidth: CGFloat = 45
    let cellsPerRow = 4
    var restaurant: RestaurantModel!
    var locatii = [LocatieModel]()
    var dataRez: String!
    var nrPers: Int = 0
    var Locat: String!
    var timeS: String = ""
    var timeE: String = ""
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        nrPersoaneCollection.dataSource = self
        nrPersoaneCollection.delegate = self
        pozeLocatii.dataSource = self
        pozeLocatii.delegate = self
        let startR = restaurant.start_rezervare
        let endR = restaurant.end_rezervare
        
        timeS = String(startR[...startR.index(startR.endIndex, offsetBy: -4)])
        timeE = String(endR[...endR.index(endR.endIndex, offsetBy: -4)])
        title = "REZERVARI (intre " + timeS + " si " + timeE + ")"
        datePicker.minimumDate = Date()
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.782, green: 0, blue: 0.194, alpha: 1)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        confirmaBtn.setTitle("CONFIRMA REZERVAREA " + restaurant.denumireRestaurant, for: UIControlState.normal)
        if restaurant.linkLocatia1 != "" {
            let locatiiArr = restaurant.linkLocatia1.components(separatedBy: ",")
            let locatie = LocatieModel(denumireLocatie: locatiiArr[0], linkLocatie: locatiiArr[1])!
            locatii.append(locatie)
        }
        
        if restaurant.linkLocatia2 != "" {
            locatii.append(LocatieModel(denumireLocatie: restaurant.linkLocatia2.components(separatedBy: ",")[0], linkLocatie: restaurant.linkLocatia2.components(separatedBy: ",")[1])!)
        }
        if restaurant.linkLocatia3 != "" {
            locatii.append(LocatieModel(denumireLocatie: restaurant.linkLocatia3.components(separatedBy: ",")[0], linkLocatie: restaurant.linkLocatia3.components(separatedBy: ",")[1])!)
        }
        if locatii.count == 1 {
            Locat = locatii[0].denumireLocatie
            locatieSelectata.text = "Locatie: " + Locat
        }
        confirmaBtnState()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        let now = NSDate()
        datePicker.minimumDate = now as Date
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - UICollectionviewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.nrPersoaneCollection {
            return 8
        } else {
            return locatii.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.nrPersoaneCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nrPersoane", for: indexPath) as! IconCategorieCollectionViewCell
            if indexPath.row < 7 {
                cell.icon.image = UIImage(named: "person")
                cell.label.text = (indexPath.row + 2).description + " persoane"
            } else {
                cell.icon.image = UIImage(named: "phone")
                cell.label.text = " 8+"
            }
            // Configure the cell
            return cell
        } else {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "locatieCell", for: indexPath) as! IconCategorieCollectionViewCell
            cell1.imagineLocatie.af_setImage(withURL: URL(string: locatii[indexPath.row].linkLocatie)!)
            cell1.textLocatie.text = locatii[indexPath.row].denumireLocatie
            return cell1
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.nrPersoaneCollection {
            var nrPersoane: Int = 0
            if indexPath.row < 7 {
                nrPersoane = indexPath.row + 2
            } else {
                if let url = URL(string: "tel://\(restaurant.telefon)"), UIApplication.shared.canOpenURL(url){
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            self.nrPers = nrPersoane
            self.nrpersoane.text = "Nr. persoane: " + nrPers.description
        } else {
            Locat = locatii[indexPath.row].denumireLocatie
            self.locatieSelectata.text = "Locatie: " + Locat
        }
        confirmaBtnState()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if collectionView == self.nrPersoaneCollection {
            
            return CGSize(width: persWidth, height: persWidth + 10.0)
        } else {
            
            let itemWidth = ((collectionView.bounds.size.width) / CGFloat(locatii.count)).rounded(.down)
            return CGSize(width: itemWidth, height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.nrPersoaneCollection {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.nrPersoaneCollection {
            var margin = collectionView.bounds.size.width - persWidth * CGFloat(cellsPerRow)
            margin = (margin / CGFloat(cellsPerRow - 1 + 4)).rounded(.down)
            return margin
        } else {
            return 0
        }
    }
    
    //MARK: - Datapicker Change
    
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        dataRez = dateFormatter.string(from: datePicker.date)
        dateFormatter.locale = Locale(identifier: "ro_RO")
        dateFormatter.dateFormat = "EEE, dd MMM YYY, HH:mm"
        datarezervarii.text = "Data: " + dateFormatter.string(from: datePicker.date)
        
        if(comparaDate(start_rezervari: restaurant.start_rezervare, end_rezervari: restaurant.end_rezervare)){
            confirmaBtnState()
        } else {
            
            showToast(messages: "Alege o ora care se incadreaza in programul restaurantului.", background: UIColor.red)
            let now = Date.init()
            datePicker.setDate(now, animated: true)
            return
        }
        
    }
    //MARK: - functii
    func comparaDate(start_rezervari: String, end_rezervari: String) -> Bool {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale(identifier: "ro_RO")
        dateFormatter1.dateFormat = "HH:mm:ss"
        let start_rezervari = dateFormatter1.date(from: start_rezervari)
        let end_rezervari = dateFormatter1.date(from: end_rezervari)
        var now = datePicker.date
        let calendar = Calendar.current
        let h = calendar.component(Calendar.Component.hour, from: now)
        let m = calendar.component(Calendar.Component.minute, from: now)
        now = dateFormatter1.date(from: "\(h):\(m):00")!
        if(start_rezervari! <= now && end_rezervari! > now){
            return true
        } else {
            return false
        }
    }
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
    //MARK: - button enabled
    func confirmaBtnState(){
        if dataRez != nil && Locat != nil && nrPers != 0 {
            confirmaBtn.isEnabled = true
        } else {
            confirmaBtn.isEnabled = false
        }
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation  */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        if let dest = segue.destination as? ConfirmaRezervareaViewController {
            dest.datarez = dataRez
            dest.locatie = Locat
            dest.nrpers = nrPers
            dest.restaurant = restaurant
        }
    }
 

}
