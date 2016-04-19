//
//  ProductListResponse.swift
//  Happy Shop
//
//  Created by Andoni Dan on 17/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import UIKit
import EVReflection

class ProductListResponse: EVObject {
    var products : [Product] = []
    
    var categories : [String : [Product]]
    {
        return ProductListResponse.productsInCategoriesFromProducts(products)
    }
    
    class func productsInCategoriesFromProducts(products : [Product]) -> [String : [Product]]
    {
        var productsInCategories : [String : [Product]] = [:]
        
        products.forEach({addProduct($0, toCollection: &productsInCategories)})
        
        return productsInCategories
    }
    
    private class func addProduct(product : Product, inout toCollection categories : [String : [Product]])
    {
        let productCategory : String = product.category ?? ""
        
        if let _ = categories[productCategory]
        {
            categories[productCategory]?.append(product)
        }
        else
        {
            categories[productCategory] = [product]
        }
    }
}
