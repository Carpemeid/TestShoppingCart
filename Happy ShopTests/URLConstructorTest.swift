//
//  URLConstructorTest.swift
//  Happy Shop
//
//  Created by Andoni Dan on 23/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import XCTest

@testable import Happy_Shop

private let kTestURL : String = "http://test.com"

class URLConstructorTest: XCTestCase {
    
    let constructor : URLConstructor = URLConstructor(baseURL: kTestURL)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProducts()
    {
        XCTAssert(constructor.products()?.absoluteString == "http://test.com/products", "Url for products is not valid")
    }
    
    func testProductId()
    {
        let id : Int = 1
        
        XCTAssert(constructor.productWithId(id)?.absoluteString == "http://test.com/products/\(id)", "url for product id is not valid")
    }
}
