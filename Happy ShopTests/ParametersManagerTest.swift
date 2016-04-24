//
//  ParametersManagerTest.swift
//  Happy Shop
//
//  Created by Andoni Dan on 23/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import XCTest

@testable import Happy_Shop

private let kKeyCategory : String = "category"
private let kKeyPage : String = "page"

class ParametersManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParameters()
    {
        let testCategoryName : String = "Bath"
        let testPageValue : Int = 1
        
        XCTAssert(!checkDictionary(ParametersManager.URLParametersForProductsInCategory(nil, atPage: nil), forKey: kKeyCategory, withValue: "bath"), "Dictionary contains strange keys")
        XCTAssert(checkDictionary(ParametersManager.URLParametersForProductsInCategory("Bath", atPage: nil), forKey: kKeyCategory, withValue: testCategoryName), "Dictionary does not contain the searched category")
        XCTAssert(checkDictionary(ParametersManager.URLParametersForProductsInCategory(nil, atPage: testPageValue), forKey: kKeyPage, withValue: "\(testPageValue)"), "Dictionary does not contain the searched page")
        
        XCTAssert(checkDictionary(ParametersManager.URLParametersForProductsInCategory(testCategoryName, atPage: testPageValue), forKeys: [kKeyCategory, kKeyPage], withValues: [testCategoryName, "\(testPageValue)"]), "The searched keys and values are not present in the dictionary")
    }
    
    func checkDictionary(dictionary : [String : String], forKeys keys : [String], withValues values : [String]) -> Bool
    {
        if keys.count == values.count
        {
            for index in 0.stride(to: keys.count, by: 1)
            {
                if !checkDictionary(dictionary, forKey: keys[index], withValue: values[index])
                {
                    return false
                }
            }
        }
        else
        {
            return false
        }
        
        return true
    }
    
    func checkDictionary(dictionary : [String : String], forKey key : String, withValue value : String) -> Bool
    {
        if let value = dictionary[key] where value == value
        {
            return true
        }
        
        return false
    }
}
