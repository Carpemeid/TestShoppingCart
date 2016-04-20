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
        Alertor(message: kMessageNoInternet)
    }
    
    init(message : String, controller : UIViewController? = nil)
    {
//        var showAdvancedAlert : Bool = true
//        
//        if (NSClassFromString(kUIAlertControllerClass) != nil)
//        {
//            if let controller = controller
//            {
//                showAdvancedAlert = false
//                iOS8Alert(message, hostController: controller)
//            }
//        }
//        
//        if !showAdvancedAlert
//        {
            elementaryAlert(message)
        //}
    }
    
    func elementaryAlert(message : String)
    {
        let alert : UIAlertView = UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: kTextButtonOk)
        alert.show()
    }
    
    func iOS8Alert(message : String, hostController : UIViewController)
    {
        let alertController : UIAlertController = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel : UIAlertAction = UIAlertAction(title: kTextButtonOk, style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(cancel)
        
        hostController.presentViewController(alertController, animated: true, completion: nil)
    }
}