//
//  ConnectionChecker.swift
//  app
//
//  Created by Andoni Dan on 01/09/15.
//  Copyright (c) 2015 taxigo. All rights reserved.
//

import Foundation

class ConnectionChecker : NSObject, ConnectionCheckerProtocol
{
    static let sharedInstance : ConnectionChecker = ConnectionChecker()
    
    func checkInternetConnection() -> Bool
    {
        return checkCellularConnectivity() || checkWirelessConnectivity()
    }
    
    private func checkCellularConnectivity() -> Bool
    {
        return Reachability.reachabilityForInternetConnection().currentReachabilityStatus().rawValue != 0
    }
    
    private func checkWirelessConnectivity() -> Bool
    {
        return Reachability.reachabilityForInternetConnection().currentReachabilityStatus().rawValue == ReachableViaWiFi.rawValue
    }
}