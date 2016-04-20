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
    //MARK: Cached data
    static var cachedCategories : [String]
    {
        set
        {
            if newValue.count > cachedCategories.count
            {
                localCategories = newValue
            }
        }
        
        get
        {
            return localCategories
        }
    }
    
    private static var localCategories : [String] = Register.categories
    
    static var cachedProductsInCart : [Product] = Register.productsInCart
    {
        didSet
        {
            NSNotificationCenter.quickPost(kNotificationCartItemsChanged)
        }
    }
    
    class func indexOfProductWithId(productId : Int?) -> Int?
    {
        if let productId = productId, index = cachedProductsInCart.indexOf({($0.id?.integerValue ?? -1) == productId})
        {
            return index
        }
        else
        {
            return nil
        }
    }
    
    class func addProductToCart(product : Product?)
    {
        if let product = product
        {
            if indexOfProductWithId(product.id?.integerValue) == .None
            {
                cachedProductsInCart.append(product)
                
                //setGenericValueForKey(product, forKey: kProductsKey)
            }
        }
    }
    
    class func removeProductFromCart(productID : Int?)
    {
        if let productIndex = indexOfProductWithId(productID)
        {
            cachedProductsInCart.removeAtIndex(productIndex)
            
            //setGenericValueForKey(productsInCart.removeAtIndex(productIndex), forKey: kProductsKey)
        }
    }
    
    class func saveToDisk()
    {
        Register.categories = cachedCategories
        Register.productsInCart = cachedProductsInCart
    }
    
    //MARK: Local storage access methods
    private class var categories : [String]
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
    
    private class var productsInCart : [Product]
    {
        set
        {
            setGenericValueForKey(newValue.map({$0.toNonNullDictionary}) , forKey: kProductsKey)
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