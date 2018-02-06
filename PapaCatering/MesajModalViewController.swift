//
//  MesajModalViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 06/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class MesajModalViewController: UIViewController {
    var restaurant: RestaurantModel!
    var persoana: String!
    @IBOutlet weak var mesajFinal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
         mesajFinal.text = restaurant.mesajCatering
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: BorderedButton) {
        
    }
    
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let istoricNavigation = segue.destination as? UINavigationController
        
        let istoricDestination = istoricNavigation?.viewControllers.first as! IstoricTableViewController
        
        istoricDestination.restaurant = restaurant
        //istoricDestination.persoana = persoana
    }
 

}
