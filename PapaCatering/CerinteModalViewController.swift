//
//  CerinteModalViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 05/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class CerinteModalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cerinteTextField: UITextField!
    var index: Int?
    var cerinteText: String?
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        cerinteTextField.delegate = self
        // Do any additional setup after loading the view.
        cerinteTextField.text = cerinteText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - OK action
    
    @IBAction func cancel(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ok(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UItextfieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
