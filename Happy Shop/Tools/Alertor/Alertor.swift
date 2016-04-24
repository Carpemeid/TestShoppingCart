//
//  Alertor.swift
//  wissmap
//
//  Created by Andoni Dan on 13/07/15.
//  Copyright (c) 2015 wissmap. All rights reserved.
//

import Foundation
import UIKit

//MARK : Local constants
private let kUIAlertControllerClass : String = "UIAlertController"

private let kTextButtonOk : String = "Ok"

private let kMessageNoInternet : String = "Please check your internet connection"

class Alertor
{    
    class func noInternet()
    {
        elementaryAlert(kMessageNoInternet)
    }
    
    private class func elementaryAlert(message : String)
    {
        let alert : UIAlertView = UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: kTextButtonOk)
        alert.show()
    }
}