//
//  Register.swift
//
//  Created by Andoni Dan on 05/10/15.
//

import Foundation

//MARK: Local constants

private let kProductsKey : String = "products"
private let kCategoriesKey : String = "categories"

class Register : NSObject
{
    //MARK: Local storage access methods
    class var categories : [String]
    {
        set
        {
            if newValue.count > categories.count
            {
                setGenericValueForKey(newValue, forKey: kCategoriesKey)
            }
        }
        
        get
        {
            guard let localCategories = genericValueForKey(kCategoriesKey) as? [String] else
            {
                return []
            }
            
            return localCategories
        }
    }
    
    class func getProductsFromCart() -> [Product]
    {
        return productsInCart
    }
    
    class func addProductToCart(product : Product)
    {
        if indexOfProductWithId(product.id?.integerValue) == .None
        {
            productsInCart.append(product)
            
            //setGenericValueForKey(product, forKey: kProductsKey)
        }
    }
    
    class func removeProductFromCart(productID : Int?)
    {
        if let productIndex = indexOfProductWithId(productID)
        {
            productsInCart.removeAtIndex(productIndex)
                
            //setGenericValueForKey(productsInCart.removeAtIndex(productIndex), forKey: kProductsKey)
        }
    }
    
    class func indexOfProductWithId(productId : Int?) -> Int?
    {
        if let productId = productId, index = productsInCart.indexOf({($0.id?.integerValue ?? -1) == productId})
        {
            return index
        }
        else
        {
            return nil
        }
    }
    
    private class var productsInCart : [Product]
    {
        set
        {
            setGenericValueForKey(newValue.map({$0.toNonNullDictionary}) , forKey: kProductsKey)
            
            NSNotificationCenter.quickPost(kNotificationCartItemsChanged)
        }
        
        get
        {
            guard let products = genericValueForKey(kProductsKey) as? [[NSObject : AnyObject]] else
            {
                return []
            }
            
            return products.map({Product(dictionary:$0)})
        }
    }
    
    //MARK: Internal methods
    private class func setValue(value : String, key : String)
    {
        setGenericValueForKey(value, forKey: key)
    }
    
    private class func setGenericValueForKey(value : AnyObject?, forKey key : String)
    {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private class func genericValueForKey(key : String) -> AnyObject?
    {
        return NSUserDefaults.standardUserDefaults().valueForKey(key)
    }
    
    private class func valueForKey(key : String) -> String
    {
        if let value = NSUserDefaults.standardUserDefaults().valueForKey(key) as? String
        {
            return value
        }
        else
        {
            return ""
        }
    }
}