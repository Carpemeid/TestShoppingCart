//
//  DiskSaver.swift
//  Happy Shop
//
//  Created by Andoni Dan on 24/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import Foundation

protocol DiskSaverProtocol
{
    func setGenericValueForKey(value : AnyObject?, forKey key : String)
    func genericValueForKey(key : String) -> AnyObject?
}

class DiskSaver : DiskSaverProtocol
{
    func setGenericValueForKey(value : AnyObject?, forKey key : String)
    {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func genericValueForKey(key : String) -> AnyObject?
    {
        return NSUserDefaults.standardUserDefaults().valueForKey(key)
    }
}