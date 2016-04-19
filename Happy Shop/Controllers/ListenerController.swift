//
//  ListenerController.swift
//  Taxigo
//
//  Created by Andoni Dan on 22/08/15.
//  Copyright (c) 2015 Eduard Dubrovski. All rights reserved.
//

import UIKit

class ListenerController: UIViewController
{
    //MARK: View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startListening()
    }
    
    deinit
    {
        stopListening()
    }
    
    func startListening()
    {
        addListeningMethods(listenerMethods())
    }
    
    func addListeningMethods(methods : [(notificationName : String, methodName : String)])
    {
        for e in methods
        {
            NSNotificationCenter.quickAddObserver(self, selector: Selector(e.methodName), name: e.notificationName)
        }
    }
    
    func stopListening()
    {
        for e in listenerMethods()
        {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: e.notificationName, object: nil)
        }
    }
    
    func listenerMethods() -> [(notificationName : String, methodName : String)]
    {
        return []
    }
}
