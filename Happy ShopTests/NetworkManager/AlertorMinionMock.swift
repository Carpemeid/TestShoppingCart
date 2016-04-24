//
//  AlertorMinionMock.swift
//  Happy Shop
//
//  Created by Andoni Dan on 21/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import Foundation
@testable import Happy_Shop

class AlertorMinionMock : AlertorProtocol
{
    var hasAlertedFlag : Bool = false
    
    func noInternet() {
        hasAlertedFlag = true
    }
}