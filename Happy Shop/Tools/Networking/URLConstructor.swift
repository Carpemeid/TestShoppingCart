//
//  URLConstructor.swift
//
//  Created by Andoni Dan on 11/06/15.
//

import Foundation

//MARK: Local variables
private let kServerURL : String = "http://sephora-mobile-takehome-2.herokuapp.com/api/v1"
private let kProductsBranch : String = "products"

class URLConstructor
{
    class func productWithId(productId : Int) -> URLConstructor
    {
        return products().append("\(productId)")
    }
    
    class func products() -> URLConstructor
    {
        return testServer().append(kProductsBranch)
    }
    
    private class func testServer() -> URLConstructor
    {
        return URLConstructor(value: kServerURL)
    }
    
    //MARK: Wrapped setters/getters
    var value : String!
    
    var url : NSURL
    {
        get
        {
            return NSURL(string: (value as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        }
    }
    
    //MARK: init
    private init(value : String)
    {
        self.value = value
    }
    
    //MARK: Helpers
    private func appendParametersString(parametersString : String) -> URLConstructor
    {
        let appendedString : String = parametersString.characters.count > 0 ? "?" + parametersString : ""
        
        //strange thing this does not work// value += appendedString
        value = value + appendedString
         
        return self
    }
    
    private func append(value : String) -> URLConstructor
    {
        self.value! += "/\(value)"
        
        return self
    }
}