//
//  IntroRestaurantViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 04/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class IntroRestaurantViewController: UIViewController {

    var restaurant: RestaurantModel?
    
    @IBOutlet weak var restaurantSelectatLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantSelectatLabel.text = restaurant?.denumireRestaurant
        restaurantSelectatLabel.textColor = UIColor.white
        restaurantLabel.textColor = UIColor.white
        //MARK: setari navigation BAR
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        //gradient
        let gradientLayer = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x:0, y:0, width: sizeLength, height: 64)
        gradientLayer.frame = defaultNavigationBarFrame
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: setare imagine fundal
        let backgroundImage = UIImage(named: "background")
        let imageView = UIImageView(image: backgroundImage)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "AfiseazaCategorii":
            guard let categoriiDestination = segue.destination as? AfisareCategoriiCollectionViewController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            categoriiDestination.restaurant = restaurant
        case "adreseleMele":
            guard let adreseNavigation = segue.destination as? UINavigationController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            let adreseDestination = adreseNavigation.viewControllers.first as! AdreseTableViewController
            adreseDestination.restaurant = restaurant
        case "profileleMele":
            guard let profileNavigation = segue.destination as? UINavigationController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            let profileDestination = profileNavigation.viewControllers.first as! ProfileTableViewController
            profileDestination.restaurant = restaurant
        case "IstoricSegue":
            guard let istoricNavigation = segue.destination as? UINavigationController
               else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            let istoricDestination = istoricNavigation.viewControllers.first as! IstoricTableViewController
            istoricDestination.restaurant = restaurant
        default:
            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
}
