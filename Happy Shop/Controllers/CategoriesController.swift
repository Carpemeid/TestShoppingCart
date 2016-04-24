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

class CategoriesController: ListenerController, FiltersControllerDelegate,ProductsCollectionDelegateProtocol {

    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: iVars
    var collectionDelegate : ProductsCollectionDelegate!
    
    var selectedCategory : String?
    {
        didSet
        {
            resetCategory()
        }
    }
    
    var shouldReplaceProducts : Bool = false
    
    var cantBePaginated : Bool = false
    {
        didSet
        {
            collectionDelegate.cantBePaginated = cantBePaginated
        }
    }
    
    var currentPage : Int?
    {
        didSet
        {
            collectionDelegate.currentPage = currentPage
        }
    }
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    var filtersNavigationController : UINavigationController?
    
    var isShoppingCartController : Bool = false
    {
        didSet
        {
            configureShoppingCartView()
        }
    }
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionDelegate = ProductsCollectionDelegate(collectionView: collectionView, delegate: self, isShoppingCartDelegate: isShoppingCartController)
        
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
            var localProducts : [Product] = register.cachedProductsInCart
            
            if let selectedCategory = selectedCategory
            {
                localProducts = localProducts.filter({$0.category == selectedCategory})
            }
            
            collectionDelegate.products = localProducts
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
                self.collectionDelegate.products = products
                self.shouldReplaceProducts = false
            }
            else
            {
                self.collectionDelegate.products.appendContentsOf(products)
            }
    
            self.refreshControl.endRefreshing()
            
            self.collectionDelegate.hideFooterInCategory(self.selectedCategory)
            
            if !atNextPage
            {
                self.collectionDelegate.scrollToTop()
            }
        }
    }
    
    //MARK: Collection view delegate methods
    func collectionViewDidSelectProduct(product : Product)
    {
        performSegueWithIdentifier(kSegueToDetails, sender: product)
    }
    
    func requestNewPage()
    {
        if let _ = currentPage, _ = selectedCategory
        {
            loadData(true)
        }
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
    }
    
    func configureShoppingCartView()
    {
        refreshBadge()
        startListening()
        
        title = kTabTitleShoppingCart
    }
    
    func refreshBadge()
    {
        navigationController?.tabBarItem.badgeValue = register.cachedProductsInCart.count == 0 ? nil : "\(register.cachedProductsInCart.count)"
        
        if isViewLoaded()
        {
            loadData()
        }
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let navController = segue.destinationViewController as? UINavigationController, filtersController = navController.viewControllers.first as? CategoryFilterController
        {
            filtersController.parent = self
            filtersNavigationController = navController
            filtersController.selectedCategoryName = selectedCategory
        }
        
        if let controller = segue.destinationViewController as? ProductDetailsController, product = sender as? Product
        {
            controller.product = product
        }
    }
    
    //MARK: Local notifications
    override func listenerMethods() -> [(notificationName: String, methodName: String)] {
        return isShoppingCartController ? [(kNotificationCartItemsChanged, kRefreshBadgeMethod)] : []
    }
}
