//
//  ViewController.swift
//  Happy Shop
//
//  Created by Andoni Dan on 17/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Networker.productWithID(1) { (product) in
            print(product)
        }
        
        Networker.productsFromCategory("Skincare", atPage: 1) { (products) in
            print(products)
        }
        // Do any additional setup after loading the view.
    }
}
