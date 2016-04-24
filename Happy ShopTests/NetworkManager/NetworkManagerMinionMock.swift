//
//  NetworkManagerMinionMock.swift
//  Happy Shop
//
//  Created by Andoni Dan on 21/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import Foundation
import EVReflection
import Alamofire
import AlamofireJsonToObjects

@testable import Happy_Shop

class NetworkManagerMinionMock<T : EVObject> : NetworkManagerProtocol<T>
{
    var responseWasCalled = false
    
    override func responseObjectWithRequest(request : Request, andCompletitionHandler handler : (Result<T, NSError>) -> Void)
    {
        responseWasCalled = true
        
        handler(Result.Failure(NSError(domain: "this is just a test", code: -1, userInfo: nil)))
    }
    
    override func responseArrayWithRequest(request : Request, andCompletitionHandler handler : (Result<[T], NSError>) -> Void)
    {
        responseWasCalled = true
        handler(Result.Failure(NSError(domain: "this is just a test", code: -1, userInfo: nil)))
    }
}