//
//  ProductListResponseTest.swift
//  Happy Shop
//
//  Created by Andoni Dan on 20/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import XCTest
@testable import Happy_Shop

class ProductListResponseTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCodeCoverage()
    {
        testProducts([])
        
        testProducts([ProductMockHelper.randomProduct( category: "c1"), ProductMockHelper.randomProduct( category: "c1")])
        
        let productWithNullCategory : Product = ProductMockHelper.randomProduct()
        productWithNullCategory.category = nil
        
        testProducts([ProductMockHelper.randomProduct( category: "c1"), ProductMockHelper.randomProduct( category: "c2"), productWithNullCategory])
    }
    
    func testRandomCoverage()
    {
        for _ in 0.stride(to: MockHelper.randomCountFrom(10, toMax: 100), by: 1)
        {
            testProducts(ProductMockHelper.randomProductsArray())
        }
    }
    
    private func testProducts(products : [Product])
    {
        let productListResponse : ProductListResponse = ProductListResponse()
        
        productListResponse.products = products
        
        testCategories(productListResponse.categories, withProducts: products)
        testCategories(ProductListResponse.productsInCategoriesFromProducts(products), withProducts: products, message: " in class method")
    }
    
    private func testCategories(categories : [String : [Product]], withProducts products : [Product], message : String = "")
    {
        XCTAssert(allProducts(products, correspondToCategories: categories), "Test failed \(message) for following products \(products)")
    }
    
    private func allProducts(products : [Product], correspondToCategories categories : [String : [Product]]) -> Bool
    {
        var mutableCopy : [String : [Product]] = categories
        
        for product in products
        {
            let localCategory : String = product.category ?? ""
            
            if let index = mutableCopy[localCategory]?.indexOf(product)
            {
                mutableCopy[localCategory]?.removeAtIndex(index)
            }
            else
            {
                return false
            }
        }
        
        return mutableCopy.flatMap({$0.1}).count == 0
    }

}
