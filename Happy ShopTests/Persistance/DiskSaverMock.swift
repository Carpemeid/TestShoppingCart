//
//  DiskSaverMock.swift
//  Happy Shop
//
//  Created by Andoni Dan on 24/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import Foundation

@testable import Happy_Shop

class DiskSaverMock : DiskSaverProtocol
{
    var dataSet : [String : AnyObject?] = [:]
    
    init(givenData : [String : AnyObject] = [:])
    {
        dataSet = givenData
    }
    
    func setGenericValueForKey(value : AnyObject?, forKey key : String)
    {
        dataSet[key] = value
    }
    
    func genericValueForKey(key : String) -> AnyObject?
    {
        return dataSet[key] ?? nil
    }
}