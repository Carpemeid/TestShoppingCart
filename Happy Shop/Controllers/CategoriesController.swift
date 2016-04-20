//
//  CategoriesController.swift
//  Happy Shop
//
//  Created by Andoni Dan on 18/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import UIKit

//MARK: Local constants
private let kSegueToFilters : String = "toFilters"
private let kSegueToDetails : String = "toDetails"

private let kTabTitleShoppingCart : String = "Shopping cart"
private let kRefreshBadgeMethod : String = "refreshBadge"

private let kCollectionViewMarginOffset : CGFloat = 5
private let kCollectionViewCellSpacing : CGFloat = 5
private let kCollectionViewCellsPerRow : Int = 2
private let kCollectionViewLoadingFooterHeight : CGFloat = 40

private let kCollectionViewCellReuseIdentifier : String = "cell"
private let kCollectionViewHeaderReuseIdentifier : String = "header"
private let kCollectionViewFooterReuseIdentifier : String = "footer"

class CategoriesController: ListenerController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FiltersControllerDelegate, UIScrollViewDelegate {

    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: iVars
    var selectedCategory : String?
    {
        didSet
        {
            resetCategory()
        }
    }
    
    var shouldReplaceProducts : Bool = false
    var hasAdditionalRow : Bool = false
    var cantBePaginated : Bool = false
    
    var currentPage : Int?
    var refreshControl : UIRefreshControl = UIRefreshControl()
    var filtersNavigationController : UINavigationController?
    
    var isShoppingCartController : Bool = false
    {
        didSet
        {
            configureShoppingCartView()
        }
    }
    
    var products : [Product] = []
    {
        didSet
        {
            productsInCategories = ProductListResponse.productsInCategoriesFromProducts(products)
        }
    }
    
    var productsInCategories : [String : [Product]] = [:]
    {
        didSet
        {
            categories = Array(productsInCategories.keys)
            
            collectionView?.reloadData()
        }
    }
    
    var categories : [String] = []
    {
        didSet
        {
            Register.cachedCategories = categories
        }
    }
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        configureRefreshController()
    }
    
    //MARK: Data management
    func resetCategory()
    {
        currentPage = selectedCategory != .None ? 1 : nil
        
        cantBePaginated = false
        shouldReplaceProducts = true
        
        loadData()
    }
    
    func loadData(atNextPage : Bool = false)
    {
        if isShoppingCartController
        {
            var localProducts : [Product] = Register.cachedProductsInCart
            
            if let selectedCategory = selectedCategory
            {
                localProducts = localProducts.filter({$0.category == selectedCategory})
            }
            
            products = localProducts
            refreshControl.endRefreshing()
            collectionView?.reloadData()
        }
        else
        {
            requestProducts(atNextPage)
        }
    }
    
    func requestProducts(atNextPage : Bool)
    {
        var pageToBeRequested : Int? = currentPage
        
        if let currentPage = currentPage where atNextPage
        {
            pageToBeRequested = currentPage + 1
        }
        
        Networker.productsFromCategory(selectedCategory, atPage: pageToBeRequested) {[unowned self] (products) in
            
            self.currentPage = pageToBeRequested
            self.cantBePaginated = products.count < 10
            
            if self.shouldReplaceProducts
            {
                self.products = products
                self.shouldReplaceProducts = false
            }
            else
            {
                self.products.appendContentsOf(products)
            }
    
            self.refreshControl.endRefreshing()
            
            self.hideFooter()
            
            if !atNextPage
            {
                self.collectionView.collectionViewLayout.collectionViewContentSize()
                
                //because force scrolling gets interrupted while layout processes happen
                NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: #selector(CategoriesController.scrollToTop), userInfo: nil, repeats: false)
            }
        }
    }
    
    func scrollToTop()
    {
        collectionView.setContentOffset(CGPointMake(0, self.collectionView.frame.origin.y - 64), animated: true)
    }
    
    //MARK: Collection view delegate methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return productsInCategories.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var numberOfItems : Int = (productsInCategories[categories[section]]?.count ?? 0)
        
        if currentPage != .None && !cantBePaginated && !needsHiddenFooter && !isShoppingCartController
        {
            numberOfItems += 1
            hasAdditionalRow = true
        }
        else
        {
            hasAdditionalRow = false
        }
        
        return numberOfItems
    }
    
    func isLoadingIndexPath(indexPath : NSIndexPath ) -> Bool
    {
        return hasAdditionalRow && indexPath.row == (productsInCategories[categories[indexPath.section]]?.count ?? 0)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let categoryCell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(isLoadingIndexPath(indexPath) ? kCollectionViewFooterReuseIdentifier : kCollectionViewCellReuseIdentifier, forIndexPath: indexPath)
        
        if let categoryCell = categoryCell as? CategoryCell
        {
            categoryCell.configureWithProduct(productsInCategories[categories[indexPath.section]]?[indexPath.row])
        }
        else
        {
            requestNewPage()
        }
        
        return categoryCell
    }
    
    func requestNewPage()
    {
        if let _ = currentPage, _ = selectedCategory
        {
            loadData(true)
        }
    }
    
    var needsHiddenFooter : Bool = false
    
    func hideFooter()
    {
        if let selectedCategory = selectedCategory, items = productsInCategories[selectedCategory], cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: items.count, inSection: 0)) where !(cell is CategoryCell)
        {
            needsHiddenFooter = true
            collectionView.deleteItemsAtIndexPaths([NSIndexPath(forRow: items.count, inSection: 0)])
            needsHiddenFooter = false
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionElementKindSectionHeader
        {
            let headerView : CategoryHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kCollectionViewHeaderReuseIdentifier, forIndexPath: indexPath) as! CategoryHeaderView
            
            headerView.cateogryNameLabel.text = categories[indexPath.section]
            
            return headerView
        }
        else
        {
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(kSegueToDetails, sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return isLoadingIndexPath(indexPath) ? CGSizeMake(collectionView.frame.width - 2*kCollectionViewMarginOffset, kCollectionViewLoadingFooterHeight) : CGSizeMake(cellEdge, cellEdge)
    }
    
    var cellEdge : CGFloat
    {
        let emptySpace : CGFloat = kCollectionViewMarginOffset * 2 + kCollectionViewCellSpacing
        
        return (UIScreen.mainScreen().bounds.width - emptySpace) / CGFloat(kCollectionViewCellsPerRow)
    }
    
    //MARK: Filters delegate methods
    func filtersControllerDidDismissWithCancel() {
        dismissFiltersController()
    }
    
    func filtersControllerDidDismissWithCategoryName(cagtegoryName: String?) {
        selectedCategory = cagtegoryName
        
        dismissFiltersController()
    }
    
    func dismissFiltersController()
    {
        filtersNavigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: View configuration
    func configureRefreshController()
    {
        refreshControl.addTarget(self, action: #selector(CategoriesController.resetCategory), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    func configureShoppingCartView()
    {
        refreshBadge()
        startListening()
        
        title = kTabTitleShoppingCart
    }
    
    func refreshBadge()
    {
        navigationController?.tabBarItem.badgeValue = Register.cachedProductsInCart.count == 0 ? nil : "\(Register.cachedProductsInCart.count)"
        loadData()
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let navController = segue.destinationViewController as? UINavigationController, filtersController = navController.viewControllers.first as? CategoryFilterController
        {
            filtersController.parent = self
            filtersNavigationController = navController
            filtersController.selectedCategoryName = selectedCategory
        }
        
        if let controller = segue.destinationViewController as? ProductDetailsController, index = collectionView.indexPathsForSelectedItems()?.first, product = productsInCategories[ categories[index.section]]?[index.row]
        {
            controller.product = product
        }
    }
    
    //MARK: Local notifications
    override func listenerMethods() -> [(notificationName: String, methodName: String)] {
        return isShoppingCartController ? [(kNotificationCartItemsChanged, kRefreshBadgeMethod)] : []
    }
}
