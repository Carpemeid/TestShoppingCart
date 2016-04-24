//
//  ProductsCollectionDelegate.swift
//  Happy Shop
//
//  Created by Andoni Dan on 24/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import UIKit

protocol ProductsCollectionDelegateProtocol
{
    func collectionViewDidSelectProduct(product : Product)
    func requestNewPage()
}

private let kCollectionViewMarginOffset : CGFloat = 5
private let kCollectionViewCellSpacing : CGFloat = 5
private let kCollectionViewCellsPerRow : Int = 2
private let kCollectionViewLoadingFooterHeight : CGFloat = 40

private let kCollectionViewCellReuseIdentifier : String = "cell"
private let kCollectionViewHeaderReuseIdentifier : String = "header"
private let kCollectionViewFooterReuseIdentifier : String = "footer"

class ProductsCollectionDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
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
            
            collectionView.reloadData()
        }
    }
    
    var categories : [String] = []
    {
        didSet
        {
            register.cachedCategories = categories
        }
    }
    
    var currentPage : Int?
    var needsHiddenFooter : Bool = false
    var cantBePaginated : Bool = false
    var hasAdditionalRow : Bool = false
    
    let collectionView : UICollectionView
    let delegate : ProductsCollectionDelegateProtocol
    let isShoppingCartController : Bool
    
    init(collectionView : UICollectionView, delegate : ProductsCollectionDelegateProtocol, isShoppingCartDelegate : Bool)
    {
        self.collectionView = collectionView
        self.delegate = delegate
        
        isShoppingCartController = isShoppingCartDelegate
        
        super.init()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    //MARK: Collection delegate methods
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
            delegate.requestNewPage()
        }
        
        return categoryCell
    }
    
    func hideFooterInCategory(category : String?)
    {
        if let selectedCategory = category, items = productsInCategories[selectedCategory], cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: items.count, inSection: 0)) where !(cell is CategoryCell)
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if let index = collectionView.indexPathsForSelectedItems()?.first, product = productsInCategories[ categories[index.section]]?[index.row]
        {
            delegate.collectionViewDidSelectProduct(product)
        }
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
    
    func scrollToTop()
    {
        collectionView.collectionViewLayout.collectionViewContentSize()
        
        //because force scrolling gets interrupted while layout processes happen
        NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: #selector(ProductsCollectionDelegate.launchScrollToTop), userInfo: nil, repeats: false)
    }
    
    func launchScrollToTop()
    {
        collectionView.setContentOffset(CGPointMake(0, self.collectionView.frame.origin.y - 64), animated: true)
    }
}
