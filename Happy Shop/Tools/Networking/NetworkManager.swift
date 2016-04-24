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

//MARK: Local constants

private let kQueueIdentifier : String = "alamofire-background-queue"

class NetworkManager <T : EVObject>
{
    //MARK: - Class functions
    class func GET(connectionChecker : ConnectionCheckerProtocol = ConnectionChecker.sharedInstance, alertor : AlertorProtocol = AlertorMinion(), minion : NetworkManagerProtocol<T> = NetworkManagerProtocol<T>()) -> NetworkManager
    {
        return NetworkManager(type: Method.GET, connectionChecker: connectionChecker, alertor: alertor, minion: minion).URL()
    }
    
    //MARK: iVars
    private var requestType : Alamofire.Method
    private var parameterEncoding :  ParameterEncoding =  ParameterEncoding.JSON
    private let connectionChecker : ConnectionCheckerProtocol
    private let alertor : AlertorProtocol
    private let minion : NetworkManagerProtocol<T>
    
    //MARK: iVar methods
    
    init(type:  Alamofire.Method, connectionChecker : ConnectionCheckerProtocol, alertor : AlertorProtocol, minion : NetworkManagerProtocol<T>)
    {
        requestType = type
        self.connectionChecker = connectionChecker
        self.alertor = alertor
        self.minion = minion
    }
    
    func URL() -> NetworkManager
    {
        parameterEncoding = ParameterEncoding.URL
        
        return self
    }
    
    //MARK: - Request constructor
    func objectAt(URLString : NSURL?, withParameters parameters : [String : AnyObject]?, inBackground : Bool, withResponseHandler responseHandler : (result : Result<T, NSError>) -> Void)
    {
        executeRequestWithURLString(URLString, parameters: parameters, inBackground: inBackground, callingHandler:
            {[unowned self]
                (request : Request, completionHandler : (Result<T, NSError>) -> Void) in
                
                self.minion.responseObjectWithRequest(request, andCompletitionHandler: completionHandler)
                
            }, withResponseHandler: responseHandler)
    }
    
    
    func arrayAt(URLString : NSURL?, withParameters parameters : [String : AnyObject]?, inBackground : Bool, withResponseHandler responseHandler : (result : Result<[T], NSError>) -> Void)
    {
        executeRequestWithURLString(URLString, parameters: parameters, inBackground: inBackground, callingHandler:
            {[unowned self]
                (request : Request, completionHandler : (Result<[T], NSError>) -> Void) in
                
                self.minion.responseArrayWithRequest(request, andCompletitionHandler: completionHandler)
            
            }, withResponseHandler: responseHandler)
    }
    
    private func executeRequestWithURLString<V>(URLString : NSURL?, parameters : [String : AnyObject]?, inBackground : Bool
        , callingHandler : (request : Request, completionHandler: (Result<V, NSError>) -> Void) -> Void
        , withResponseHandler responseHandler : (result : Result<V, NSError>) -> Void)
    {
        if let instance = requestInstanceWithURLString(URLString, parameters: parameters, inBackground: inBackground)
        {
            callingHandler(request: instance.request, completionHandler: { (result: Result<V, NSError>) in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                responseHandler(result: result)
            })
        }
        else
        {
            alertor.noInternet()
            
            responseHandler(result: Result.Failure(NSError(domain: "No internet", code: 404, userInfo: nil)))
        }
    }

    
    private func requestInstanceWithURLString(url : NSURL?, parameters : [String : AnyObject]?, inBackground : Bool) -> (request : Request,queue : dispatch_queue_t)?
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if let url = url where connectionChecker.checkInternetConnection()
        {
            let queue : dispatch_queue_t = inBackground ? dispatch_queue_create(kQueueIdentifier, DISPATCH_QUEUE_CONCURRENT) : dispatch_get_main_queue()
            
            let localRequest : Request = request(requestType, url, parameters: parameters, encoding: parameterEncoding, headers: nil)
            
            print("request url is \(localRequest.request?.URL)")
            
            return (localRequest, queue)
        }
        else
        {
            if url == .None
            {
                print("request failed to create for url \(url)")
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            return nil
        }
    }
}