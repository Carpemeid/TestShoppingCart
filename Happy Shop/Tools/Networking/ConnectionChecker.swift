//
//  ConnectionChecker.swift
//  app
//
//  Created by Andoni Dan on 01/09/15.
//  Copyright (c) 2015 taxigo. All rights reserved.
//

import Foundation

class ConnectionChecker : NSObject
{    
    class func checkInternetConnection() -> Bool
    {
        return checkCellularConnectivity() || checkWirelessConnectivity()
    }
    
    class func checkCellularConnectivity() -> Bool
    {
        return Reachability.reachabilityForInternetConnection().currentReachabilityStatus().rawValue != 0
    }
    
    class func checkWirelessConnectivity() -> Bool
    {
        return Reachability.reachabilityForInternetConnection().currentReachabilityStatus().rawValue == ReachableViaWiFi.rawValue
    }

}