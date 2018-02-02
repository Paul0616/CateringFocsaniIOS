//
//  RestauranteTableViewController.swift
//  PapaCatering
//
//  Created by Paul Oprea on 01/02/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Firebase

class RestauranteTableViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        self.tableView.backgroundView = imageView
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //MARK: setari navigation BAR gradient
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       self.navigationController!.navigationBar.shadowImage = UIImage()
       self.navigationController!.navigationBar.isTranslucent = true
        //gradient
        let gradientLayer = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x:0, y:0, width: sizeLength, height: 64)
        gradientLayer.frame = defaultNavigationBarFrame
        
        //gradientLayer.frame = self.navigationController!.navigationBar.frame
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x:0.5, y:0.1)
        gradientLayer.endPoint = CGPoint(x:0.5, y:1)
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
    }

}

