//
//  URLConstructor.swift
//
//  Created by Andoni Dan on 11/06/15.
//

import Foundation

//MARK: Local variables
private let kServerURL : String = "http://sephora-mobile-takehome-2.herokuapp.com/api/v1"
private let kProductsBranch : String = "products"

var urlConstructor : URLConstructor
{
    return URLConstructor.sharedInstance
}

class URLConstructor
{
    private static let sharedInstance : URLConstructor = URLConstructor(baseURL: kServerURL)
    
    private var baseURL : NSURL?
    
    init(baseURL : String)
    {
        self.baseURL = NSURL(string: baseURL)
    }

    func productWithId(productId : Int) -> NSURL?
    {
        return products()?.URLByAppendingPathComponent("\(productId)")
    }
    
    func products() -> NSURL?
    {
        return baseURL?.URLByAppendingPathComponent(kProductsBranch)
    }
}