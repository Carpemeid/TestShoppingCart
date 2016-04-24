//
//  Register.swift
//
//  Created by Andoni Dan on 05/10/15.
//

import Foundation

//MARK: Local constants

private let kProductsKey : String = "products"
private let kCategoriesKey : String = "categories"

var register : Register
{
    return Register.sharedInstance
}

class Register : NSObject
{
    //MARK: Singleton
    static let sharedInstance : Register = Register(localDiskSaver: DiskSaver(), localDiskNotifier: DiskNotifier())
    
    //MARK: iVars
    private var diskSaver : DiskSaverProtocol
    private var localCategories : [String] = []
    private var diskNotifier : DiskNotifierProtocol
    
    
    //MARK: Cached data
    var cachedProductsInCart : [Product]
    {
        get
        {
            return _cachedProductsInCart
        }
    }
    
    private var _cachedProductsInCart : [Product] = []
    {
        didSet
        {
            diskNotifier.didChangeProductsInCart()
        }
    }
    
    var cachedCategories : [String]
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
    
    init(localDiskSaver : DiskSaverProtocol, localDiskNotifier : DiskNotifierProtocol)
    {
        diskSaver = localDiskSaver
        diskNotifier = localDiskNotifier
        super.init()
        localCategories = categories
        _cachedProductsInCart = productsInCart
    }
    
    func addProductToCart(product : Product?)
    {
        if let product = product where product.id != .None && indexOfProductWithId(product.id?.integerValue) == .None
        {
            _cachedProductsInCart.append(product)
        }
    }
    
    func removeProductFromCart(productID : Int?)
    {
        if let productIndex = indexOfProductWithId(productID)
        {
            _cachedProductsInCart.removeAtIndex(productIndex)
        }
    }
    
    func indexOfProductWithId(productId : Int?) -> Int?
    {
        if let productId = productId, index = _cachedProductsInCart.indexOf({($0.id?.integerValue ?? -1) == productId})
        {
            return index
        }
        else
        {
            return nil
        }
    }
    
    func saveToDisk()
    {
        categories = cachedCategories
        productsInCart = _cachedProductsInCart
    }
    
    //MARK: Local storage access methods
    private var categories : [String]
    {
        set
        {
            if newValue.count > categories.count
            {
                diskSaver.setGenericValueForKey(newValue, forKey: kCategoriesKey)
            }
        }
        
        get
        {
            guard let localCategories = diskSaver.genericValueForKey(kCategoriesKey) as? [String] else
            {
                return []
            }
            
            return localCategories
        }
    }
    
    private var productsInCart : [Product]
    {
        set
        {
            diskSaver.setGenericValueForKey(newValue.map({$0.toNonNullDictionary}) , forKey: kProductsKey)
        }
        
        get
        {
            guard let products = diskSaver.genericValueForKey(kProductsKey) as? [[NSObject : AnyObject]] else
            {
                return []
            }
            
            return products.map({Product(dictionary:$0)})
        }
    }
}