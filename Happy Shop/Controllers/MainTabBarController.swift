//
//  MainTabBarController.swift
//  Happy Shop
//
//  Created by Andoni Dan on 18/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import UIKit

private let kTabCategoryTitle : String = "Categories"
private let kTabShoppingCartTitle : String = "Shopping cart"

private let kTabCategoryIconName : String = "listIcon"
private let kTabShoppingCartIconName : String = "shoppingCartIcon"

private let kShoppingCartControllerIndex : Int = 1
private let kRootViewControllerIndex : Int = 0

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0.stride(to: viewControllers?.count ?? 0, by: 1)
        {
            if let navController = viewControllers?[index] as? UINavigationController
            {
                navController.tabBarItem.title = [kTabCategoryTitle, kTabShoppingCartTitle][index]
                navController.tabBarItem.image = UIImage(named: [kTabCategoryIconName, kTabShoppingCartIconName][index])
                
                if let controller = navController.viewControllers[kRootViewControllerIndex] as? CategoriesController where index == kShoppingCartControllerIndex
                {
                    controller.isShoppingCartController = true
                }
            }
        }
    }
}
