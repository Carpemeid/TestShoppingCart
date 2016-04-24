//
//  MockHelper.swift
//  Happy Shop
//
//  Created by Andoni Dan on 21/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import Foundation

class MockHelper
{
    static var randomString : String?
    {
        return randomNumber()?.stringValue
    }
    
    static func randomCountFrom(minimum : Int,toMax maximum : Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(maximum - minimum))) + minimum
    }
    
    static func randomNumber(withNull : Bool = true) -> NSNumber?
    {
        let randomInt : Int = randomCountFrom(-1000, toMax: 100000)
        
        if randomInt == 0 && withNull
        {
            return randomCountFrom(0, toMax: 2) == 0 ? nil : NSNumber(integer: 0)
        }
        
        return NSNumber(integer: randomInt)
    }
}