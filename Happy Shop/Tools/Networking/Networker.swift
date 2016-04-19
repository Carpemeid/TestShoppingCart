//
//  Networker.swift
//  Happy Shop
//
//  Created by Andoni Dan on 17/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import UIKit
import Alamofire

class Networker: NSObject {
    
    //I saw that even though in the documentation is specified that category is a mandatory parameter, you can request without it
    //and thus, because I had another design approach in mind, I put the category parameter as optional in order to be able to load 
    //even random products just by page
    class func productsFromCategory(category : String?, atPage page : Int?, responseHandler : (products : [Product]) -> Void)
    {
        NetworkManager.GET().URL().objectAt(URLConstructor.products().value, withParameters: ParametersManager.URLParametersForProductsInCategory(category, atPage: page), inBackground: false) { (result : Result<ProductListResponse, NSError>) in
            
            responseHandler(products: result.value?.products ?? [])
        }
    }
    
    class func productWithID(productId : Int, responseHandler : (product : Product?) -> Void)
    {
        NetworkManager.GET().URL().objectAt(URLConstructor.productWithId(productId).value, withParameters: nil, inBackground: false) { (result : Result<ProductResponse, NSError>) in
            
            responseHandler(product: result.value?.product)
        }
    }
}
