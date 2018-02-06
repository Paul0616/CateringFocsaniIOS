//
//  MesajRezervareViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 04/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class MesajRezervareViewController: UIViewController {
    var restaurant: RestaurantModel!
    @IBOutlet weak var mesajRezervareLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mesajRezervareLabel.text = restaurant.mesajRezervare
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ok(_ sender: BorderedButton) {
        self.dismiss(animated: true, completion: nil)
     
    }
    
    /*
    // MARK: - Navigation
        */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        //switch (segue.identifier ?? "") {
       // case "doneRezervare":
            //guard let navigation = segue.destination as? UINavigationController
               // else{
                //    fatalError("Unexpected destination: \(segue.destination)")
            //}
            //let destination = navigation.viewControllers.first as! ProfileTableViewController
            
            
      //  default:
       //     fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
       // }
    }
 

}
