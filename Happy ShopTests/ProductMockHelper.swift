//
//  ProductMockHelper.swift
//  Happy Shop
//
//  Created by Andoni Dan on 21/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import Foundation
@testable import Happy_Shop

class ProductMockHelper
{
    class func randomProductsArray() -> [Product]
    {
        return Array(0.stride(to: MockHelper.randomCountFrom(0, toMax: 1000), by: 1).map({_ in randomProduct()}))
    }
    
    class func randomProduct(id : NSNumber? = nil, name : String? = nil, category : String? = nil, price : NSNumber? = nil, _description : String? = nil, under_sale : NSNumber? = nil, img_url : String? = nil) -> Product
    {
        return newProduct(id ?? MockHelper.randomNumber(), name: name ?? MockHelper.randomString, category: category ?? MockHelper.randomString, price: price ?? MockHelper.randomNumber(), _description: _description ?? MockHelper.randomString, under_sale: under_sale ?? MockHelper.randomNumber(), img_url: img_url ?? MockHelper.randomString)
    }
    
    class var nonNullIdRandomProduct : Product
    {
        let randomNumber : NSNumber = MockHelper.randomNumber(false)!
        
        return ProductMockHelper.newProduct(randomNumber, name: "asd", category: "asda", price: MockHelper.randomNumber(), _description: MockHelper.randomString, under_sale: MockHelper.randomNumber(), img_url: MockHelper.randomString)
    }
    
    class func newProduct(
        id : NSNumber?
        , name : String?
        , category : String?
        , price : NSNumber?
        , _description : String?
        , under_sale : NSNumber?
        , img_url : String? 
        ) -> Product
    {
        let product : Product = Product()
        
        product.id = id
        product.name = name
        product.category = category
        product.price = price
        product._description = _description
        product.under_sale = under_sale
        product.img_url = img_url
        
        return product
    }
}