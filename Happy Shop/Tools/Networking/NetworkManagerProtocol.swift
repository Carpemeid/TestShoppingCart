//
//  NetworkManagerProtocol.swift
//  Happy Shop
//
//  Created by Andoni Dan on 21/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection
import AlamofireJsonToObjects

class NetworkManagerProtocol<T : EVObject>
{
    func responseObjectWithRequest(request : Request, andCompletitionHandler handler : (Result<T, NSError>) -> Void)
    {
        request.responseObject(completionHandler: handler)
    }
    
    func responseArrayWithRequest(request : Request, andCompletitionHandler handler : (Result<[T], NSError>) -> Void)
    {
        request.responseArray(completionHandler: handler)
    }
}