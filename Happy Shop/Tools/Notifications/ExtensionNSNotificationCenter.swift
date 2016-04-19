//
//  ExtensionNSNotificationCenter.swift
//  wissmap
//
//  Created by Andoni Dan on 13/07/15.
//  Copyright (c) 2015 wissmap. All rights reserved.
//

import Foundation

let kNotificationCartItemsChanged : String = "cartItemsChanged"

extension NSNotificationCenter
{
    class func quickAddObserver(observer : AnyObject, selector : Selector, name : String)
    {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    class func quickPost(notificationName : String)
    {
        post(notificationName, data: nil)
    }
    
    class func quickRemoveObserver(observer : AnyObject)
    {
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    
    class func postWithData(notificationName : String, data : [NSObject : AnyObject]?)
    {
        post(notificationName, data: data)
    }
    
    private class func post(notificationName : String, data : [NSObject : AnyObject]?)
    {
        dispatch_async(dispatch_get_main_queue(),
            {
                () -> Void in
                
                NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil, userInfo: data)
        })
        
    }}