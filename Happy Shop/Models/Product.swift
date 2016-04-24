//
//  Product.swift
//  Happy Shop
//
//  Created by Andoni Dan on 15/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import UIKit
import EVReflection

class Product: EVObject {
    
    var id : NSNumber?
    var name : String?
    var category : String?
    var price : NSNumber?
    var _description : String?
    var under_sale : NSNumber?
    
    var img_url : String?
}
