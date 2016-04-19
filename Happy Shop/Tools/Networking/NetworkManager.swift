//
//  NetworkManager.swift
//  VoteMyStyle
//
//  Created by Andoni Dan on 04/03/15.
//  Copyright (c) 2015 rosoftlab. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireJsonToObjects
import EVReflection

class NetworkManager
{
    //MARK: - Class functions
    class func GET() -> NetworkManager
    {
        return NetworkManager(type: Method.GET)
    }
    
    class func POST() -> NetworkManager
    {
        return NetworkManager(type: Method.POST)
    }
    
    //MARK: iVars
    
    private var requestType : Alamofire.Method
    private var parameterEncoding :  ParameterEncoding =  ParameterEncoding.JSON
    
    //MARK: iVar methods
    
    init(type:  Alamofire.Method)
    {
        requestType = type
    }
    
    func URL() -> NetworkManager
    {
        parameterEncoding = ParameterEncoding.URL
        
        return self
    }
    
    //MARK: - Request constructor
    private func requestInstanceWithURLString(URLString : URLStringConvertible, parameters : [String : AnyObject]?, inBackground : Bool) -> (request : Request,queue : dispatch_queue_t)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let queue : dispatch_queue_t = inBackground ? dispatch_queue_create("alamofire-background-queue", DISPATCH_QUEUE_CONCURRENT) : dispatch_get_main_queue()
        
        return (request(requestType, URLString, parameters: parameters, encoding: parameterEncoding, headers: nil), queue)
    }
    
    func objectAt<T : EVObject>(URLString : URLStringConvertible, withParameters parameters : [String : AnyObject]?, inBackground : Bool, withResponseHandler responseHandler : (result : Result<T, NSError>) -> Void)
    {
        let instance : (request : Request, queue : dispatch_queue_t) = requestInstanceWithURLString(URLString, parameters: parameters, inBackground: inBackground)
        
        instance.request.responseObject(instance.queue, encoding: NSUTF8StringEncoding) { (request : NSURLRequest?, response : NSHTTPURLResponse?, result : Result<T, NSError>) in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            responseHandler(result: result)
        }
    }
    
    func arrayAt<T : EVObject>(URLString : URLStringConvertible, withParameters parameters : [String : AnyObject]?, inBackground : Bool, withResponseHandler responseHandler : (result : Result<[T], NSError>) -> Void)
    {
        let instance : (request : Request, queue : dispatch_queue_t) = requestInstanceWithURLString(URLString, parameters: parameters, inBackground: inBackground)
        
        instance.request.responseArray(instance.queue, encoding: NSUTF8StringEncoding) { (request : NSURLRequest?, response : NSHTTPURLResponse?, result : Result<[T], NSError>) in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            responseHandler(result: result)
        }
    }
}