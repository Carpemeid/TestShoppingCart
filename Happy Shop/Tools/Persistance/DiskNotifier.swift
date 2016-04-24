//
//  DiskNotifier.swift
//  Happy Shop
//
//  Created by Andoni Dan on 24/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import Foundation

protocol DiskNotifierProtocol
{
    func didChangeProductsInCart()
}

class DiskNotifier : DiskNotifierProtocol
{
    func didChangeProductsInCart()
    {
        NSNotificationCenter.quickPost(kNotificationCartItemsChanged)
    }
}