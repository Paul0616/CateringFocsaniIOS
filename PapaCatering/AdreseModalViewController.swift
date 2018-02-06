//
//  AdreseModalViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class AdreseModalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var localitate: UIPickerView!
    @IBOutlet weak var adresa: UITextField!
    var index: Int?
    var adresaText: String?
    var localitateaText = ["Focsani"]
    var localitateAleasa: String = "Focsani"
    var adresaModel: AdresaModel?
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adresa.text = adresaText
        self.localitate.dataSource = self
        self.localitate.delegate = self
        self.adresa.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for i in 0...(localitateaText.count-1){
            if localitateaText[i] == localitateAleasa {
                self.localitate.selectRow(i, inComponent: 0, animated: true)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - private
    
    @IBAction func cancel(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    @IBAction func ok(_ sender: UIButton) {
    }
    
    //MARK: - UItextfieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - UIPIcker
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return localitateaText.count
    }
    
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return localitateaText[row]
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        localitateAleasa = localitateaText[row]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        adresaModel = AdresaModel(selected: true, adresa: adresa.text!, localitate: localitateAleasa)!
    }
 

}
