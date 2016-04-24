//
//  CategoryFilterController.swift
//  Happy Shop
//
//  Created by Andoni Dan on 18/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import UIKit

protocol FiltersControllerDelegate
{
    func filtersControllerDidDismissWithCategoryName(cagtegoryName : String?)
    func filtersControllerDidDismissWithCancel()
}

//MARK: Local constants
private let kCellIdentifier : String = "cell"

class CategoryFilterController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: iVars
    var parent : FiltersControllerDelegate?
    var selectedCategoryName : String?
    var categories : [String] = register.cachedCategories
    
    //MARK: View life cycle

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!

    //MARK: Tableview delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        cell.selectedBackgroundView = UIView()
        
        if let selectedCategoryName = selectedCategoryName, index = categories.indexOf(selectedCategoryName) where index == indexPath.row
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        markCellAtIndexPath(indexPath, withAccessoryType: UITableViewCellAccessoryType.Checkmark)
        
        if let localCategoryName = selectedCategoryName, index = categories.indexOf(localCategoryName)
        {
            selectedCategoryName = index == indexPath.row ? nil : categories[indexPath.row]
            
            markCellAtIndexPath(NSIndexPath(forRow: index, inSection: 0), withAccessoryType: UITableViewCellAccessoryType.None)
        }
        else
        {
            selectedCategoryName = categories[indexPath.row]
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func markCellAtIndexPath(indexPath : NSIndexPath, withAccessoryType accessoryType : UITableViewCellAccessoryType)
    {
        if let cell = tableView.cellForRowAtIndexPath(indexPath)
        {
            cell.accessoryType = accessoryType
        }
    }
    
    //MARK: Events
    @IBAction func dismissAction(sender: AnyObject) {
        parent?.filtersControllerDidDismissWithCancel()
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        parent?.filtersControllerDidDismissWithCategoryName(selectedCategoryName)
    }
    
}
