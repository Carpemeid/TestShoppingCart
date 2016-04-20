//
//  ProductDetailsController.swift
//  Happy Shop
//
//  Created by Andoni Dan on 19/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import UIKit

class ProductDetailsController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var onSaleLabel: UILabel!
    
    var hasLoaded : Bool = false
    
    var product : Product?
    {
        didSet
        {
            if hasLoaded
            {
                configureWithProduct(product)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWithProduct(product)
        loadProductWithId(product?.id?.integerValue)
        
        hasLoaded = true
    }
    
    //MARK: Data load
    func loadProductWithId(productId : Int?)
    {
        if let productId = productId
        {
            Networker.productWithID(productId, responseHandler: {[unowned self] (product) in
                
                if let product = product
                {
                    self.product = product
                }
            })
        }
    }
    
    //MARK: View configuration
    func configureWithProduct(product : Product?)
    {
        if let product = product
        {
            if let url = NSURL(string: product.img_url ?? "")
            {
                productImageView.sd_setImageWithURL(url)
            }
            
            productDescriptionLabel.text = product._description
            productNameLabel.text = product.name
            
            if let price = product.price?.floatValue
            {
                productPriceLabel.text = "S$" + String(format: "%.2f", price)
            }
            
            if let onSale = product.under_sale?.boolValue
            {
                onSaleLabel.hidden = !onSale
            }
            
            if let _ = Register.indexOfProductWithId(product.id?.integerValue)
            {
                configureAddToCartButtonWithState(true)
            }
        }
    }
    
    func configureAddToCartButtonWithState(isInCart : Bool)
    {
        addToCartButton.setTitle(!isInCart ? "Add to cart" : "Remove from cart", forState: UIControlState.Normal)
    }
    
    //MARK: Events
    @IBAction func addToCartAction(sender: AnyObject) {
        
        if let _ = Register.indexOfProductWithId(product?.id?.integerValue)
        {
            Register.removeProductFromCart(product?.id?.integerValue)
            
            configureAddToCartButtonWithState(false)
        }
        else
        {
            Register.addProductToCart(product)
            configureAddToCartButtonWithState(true)
        }
        
    }
    
}
