//
//  ExtensionEVObject.swift
//  Happy Shop
//
//  Created by Andoni Dan on 19/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import Foundation
import EVReflection

extension EVObject
{
    var toNonNullDictionary : NSDictionary
    {
        var localDictionary : NSDictionary = toDictionary()
        
        if let mutableDictionary = localDictionary.mutableCopy() as? NSMutableDictionary
        {
            mutableDictionary.removeObjectsForKeys(mutableDictionary.allKeysForObject(NSNull()))
            
            if let clone = mutableDictionary.copy() as? NSDictionary
            {
                localDictionary = clone
            }
        }
        
        return localDictionary
    }
}