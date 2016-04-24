//
//  DiskNotifierMock.swift
//  Happy Shop
//
//  Created by Andoni Dan on 24/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import Foundation
@testable import Happy_Shop

class DiskNotifierMock : DiskNotifierProtocol
{
    var changedProductsInCart : Bool = false
    
    func didChangeProductsInCart() {
        changedProductsInCart = true
    }
}