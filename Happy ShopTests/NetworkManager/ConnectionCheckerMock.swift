//
//  ConnectionCheckerMock.swift
//  Happy Shop
//
//  Created by Andoni Dan on 21/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import Foundation
@testable import Happy_Shop

class ConnectionCheckerMock : ConnectionCheckerProtocol
{
    var internetValue : Bool = false
    
    func checkInternetConnection() -> Bool {
        return internetValue
    }
}