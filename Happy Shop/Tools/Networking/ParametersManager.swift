//
//  ParametersManager.swift
//  Ranx
//
//  Created by Andoni Dan on 26/09/15.
//  Copyright © 2015 Arup Paul. All rights reserved.
//

import Foundation

//MARK: Local constants
private let kCategoryParameter : String = "category"
private let kPageParameter : String = "page"

class ParametersManager
{
    class func URLParametersForProductsInCategory(category : String?, atPage page : Int?) -> [String : String]
    {
        var parameters : [String : String] = [:]
        
        if let page = page where page > 0
        {
            parameters[kPageParameter] = "\(page)"
        }
        
        if let category = category
        {
            parameters[kCategoryParameter] = category
        }

        return parameters
    }
    
}