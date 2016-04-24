//
//  RegiterTest.swift
//  Happy Shop
//
//  Created by Andoni Dan on 24/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import XCTest

@testable import Happy_Shop

class RegiterTest: XCTestCase {
    
    let diskSaver : DiskSaverMock = DiskSaverMock()
    let diskNotifier : DiskNotifierMock = DiskNotifierMock()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNotifier()
    {
        diskNotifier.changedProductsInCart = false
        
        let localRegister : Register = Register(localDiskSaver: diskSaver, localDiskNotifier: diskNotifier)
        
        localRegister.addProductToCart(ProductMockHelper.nonNullIdRandomProduct)
        
        XCTAssert(diskNotifier.changedProductsInCart, "After adding a product to cart the notification for products changed, was not sent")
    }
    
    func testCachedCategories()
    {
        let localRegister : Register = Register(localDiskSaver: diskSaver, localDiskNotifier: diskNotifier)
        
        let manyCategories : [String] = ["category1","category2","category3"]
        
        localRegister.cachedCategories = manyCategories
        
        let lessCategories : [String] = ["category1", "category2"]
        
        localRegister.cachedCategories = lessCategories
        
        XCTAssert(localRegister.cachedCategories.count == manyCategories.count, "The array categories with more items has been overriden by less items")
    }
    
    func testRemoveProduct()
    {
        let randomNonNullProduct : Product = ProductMockHelper.nonNullIdRandomProduct
        
        changeProductsInDataSetTo([randomNonNullProduct])
        
        let localRegister : Register = Register(localDiskSaver: diskSaver, localDiskNotifier: diskNotifier)
        
        localRegister.removeProductFromCart(randomNonNullProduct.id?.integerValue)
        
        XCTAssert(localRegister.indexOfProductWithId(randomNonNullProduct.id?.integerValue) == .None, "Product with non null ID was not removed")
        
        let randomNullIdProduct : Product = ProductMockHelper.randomProduct()
        randomNullIdProduct.id = nil
        randomNullIdProduct.name = "test"
        changeProductsInDataSetTo([randomNullIdProduct])
        
        let localNullRegister : Register = Register(localDiskSaver: diskSaver, localDiskNotifier: diskNotifier)
        
        localNullRegister.removeProductFromCart(randomNullIdProduct.id?.integerValue)
        
        XCTAssert(localNullRegister.cachedProductsInCart.filter({$0.name == "test"}).count > 0, "Product with null ID was removed")
    }
    
    func testAddProduct()
    {
        diskSaver.dataSet = [:]
        
        let randomNonNullProduct : Product = ProductMockHelper.nonNullIdRandomProduct
        
        let localNonNullRegister : Register = Register(localDiskSaver: diskSaver, localDiskNotifier: diskNotifier)
        localNonNullRegister.addProductToCart(randomNonNullProduct)
        
        XCTAssert(localNonNullRegister.indexOfProductWithId(randomNonNullProduct.id?.integerValue) != .None, "Product with non null id was not added")
        
        let sameProductIdDifferentName : Product = ProductMockHelper.randomProduct()
        sameProductIdDifferentName.id = randomNonNullProduct.id
        sameProductIdDifferentName.name = "test"
        
        localNonNullRegister.addProductToCart(sameProductIdDifferentName)
        
        XCTAssert(localNonNullRegister.cachedProductsInCart.filter({$0.name == "test"}).count == 0, "Product with same id was added")
        
        let randomNullProduct : Product = ProductMockHelper.randomProduct()
        randomNullProduct.id = nil
        randomNullProduct.name = "test"
        
        diskSaver.dataSet = [:]
        
        let localNullRegister : Register = Register(localDiskSaver: diskSaver, localDiskNotifier: diskNotifier)
        
        localNullRegister.addProductToCart(randomNullProduct)
        
        XCTAssert(localNullRegister.cachedProductsInCart.filter({$0.name == "test"}).count == 0, "Product with null id was added")
    }
    
    func testSaveOnDisk()
    {
        diskSaver.dataSet = [:]
        
        let randomProduct : Product = ProductMockHelper.nonNullIdRandomProduct
        let newCategory : String = MockHelper.randomNumber(false)!.stringValue
        
        let localRegister : Register = Register(localDiskSaver: diskSaver, localDiskNotifier: diskNotifier)
        
        localRegister.cachedCategories.append(newCategory)
        
        localRegister.addProductToCart(randomProduct)
        
        localRegister.saveToDisk()

        var productWasFound : Bool = false
        
        if let dictionaries = diskSaver.dataSet["products"] as? [[NSObject : AnyObject]]
        {
            let products : [Product] = dictionaries.map({Product(dictionary:$0)})
            
            if let index = products.indexOf({($0.id?.integerValue ?? -1) == randomProduct.id!})
            {
                productWasFound = true
            }
        }
        
        var categoryWasFound : Bool = false
        
        if let categories = diskSaver.dataSet["categories"] as? [String]
        {
            if let index = categories.indexOf(newCategory)
            {
                categoryWasFound = true
            }
        }
        
        XCTAssert(productWasFound && categoryWasFound, "Saving to disk is unsuccessful. The added product or category was not found")
    }
    
    func testIndexOfProduct()
    {
        runTestIndexOfProductOnFirstLoad()
        runTestIndexOfProductAfterFirstLoad()
        runTestForIndexOfProductWithNullId()
    }
    
    func runTestForIndexOfProductWithNullId()
    {
        let nullIdProduct : Product = ProductMockHelper.randomProduct()
        nullIdProduct.id = nil
        
        changeProductsInDataSetTo([nullIdProduct])
        
        let localRegister : Register = Register(localDiskSaver: diskSaver, localDiskNotifier: diskNotifier)
        
        XCTAssert(localRegister.indexOfProductWithId(nil) == .None, "A nil index returned a product")
    }
    
    func runTestIndexOfProductOnFirstLoad()
    {
        let randomProduct : Product = ProductMockHelper.nonNullIdRandomProduct
        
        changeProductsInDataSetTo([randomProduct])
        
        let registerWithData : Register = Register(localDiskSaver: diskSaver, localDiskNotifier: diskNotifier)
        
        XCTAssert(registerWithData.indexOfProductWithId(randomProduct.id?.integerValue) != .None, "The searched product is not in the register")
        
        diskSaver.dataSet = [:]
        
        let registerWithoutData : Register = Register(localDiskSaver: diskSaver, localDiskNotifier: diskNotifier)
        
        XCTAssert(registerWithoutData.indexOfProductWithId(2) == .None, "An inexisting product has been found")
    }
    
    func runTestIndexOfProductAfterFirstLoad()
    {
        diskSaver.dataSet = [:]
        
        let product : Product = ProductMockHelper.nonNullIdRandomProduct
        
        let localRegister : Register = Register(localDiskSaver: diskSaver, localDiskNotifier: diskNotifier)
        
        XCTAssert(localRegister.indexOfProductWithId(product.id?.integerValue) == .None, "an inexistent product has been found")
        
        localRegister.addProductToCart(product)
        
        XCTAssert(localRegister.indexOfProductWithId(product.id?.integerValue) != .None, "an existent product has not been found")
    }
    
    func changeProductsInDataSetTo(products : [Product])
    {
        diskSaver.dataSet = ["products" : products.map({$0.toDictionary()})]
    }
}
