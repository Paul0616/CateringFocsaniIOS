//
//  ProfileModalViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 04/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class ProfileModalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var numeTextField: UITextField!
    @IBOutlet weak var telefonTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    var index: Int?
    var numeText: String?
    var telefonText: String?
    var profilModel: ProfilModel?
    let numberToolbar: UIToolbar = UIToolbar()
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numeTextField.text = numeText
        self.telefonTextField.text = telefonText
        self.telefonTextField.delegate = self
        self.numeTextField.delegate = self
        // Do any additional setup after loading the view.
        updateSaveButtonState()
        numberToolbar.barStyle = UIBarStyle.default
        
        numberToolbar.items=[
            UIBarButtonItem(title: "Sterge numarul", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileModalViewController.stergeNumarul)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Return", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileModalViewController.inchideKeyboard))
        ]
        
        numberToolbar.sizeToFit()
        
        telefonTextField.inputAccessoryView = numberToolbar //do it for every relevant textfield if there are more than one
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - UItextfieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        okBtn.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        
    }

    //MARK: - Private methods
    @objc func inchideKeyboard() {
        telefonTextField.resignFirstResponder()
    }
    
    @objc func stergeNumarul() {
        telefonTextField.text=""
        telefonTextField.resignFirstResponder()
    }
    
    private func updateSaveButtonState(){
        var text = telefonTextField.text ?? ""
        text = onlyNumbers(text: text)
        telefonTextField.text = text
        errorLabel.text = ""
        var okEnable: Bool = true
        okEnable = !text.isEmpty && okEnable
        if(!text.isEmpty){
            let index = text.index(text.startIndex, offsetBy: 1)
            //var test = text[..<index]
            okEnable = okEnable && (text[..<index] == "0")
            if (text[..<index] != "0"){
                errorLabel.text = "Nr de telefon trebuie sa inceapa cu zero"
            }
            
            okEnable = okEnable && (text.count == 10)
            if (text.count != 10){
                errorLabel.text = "Nr de telefon trebuie sa fie de 10 cifre"
            }
        } else {
            errorLabel.text = "Nr de telefon e obligatoriu"
        }
        okBtn.isEnabled = okEnable
    }
    
    func onlyNumbers(text: String) -> String {
        let okayChars : Set<Character> = Set("1234567890")
        return String(text.filter {okayChars.contains($0) })
    }
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ok(_ sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation
    */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        profilModel = ProfilModel(selected: true, nickName: numeTextField.text!, telefon: telefonTextField.text!)
    }
 

}
