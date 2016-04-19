//
//  CategoryCell.swift
//  Happy Shop
//
//  Created by Andoni Dan on 18/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    func configureWithProduct(product : Product?)
    {
        if let product = product
        {
            if let url = NSURL(string: product.img_url ?? "")
            {
                productImageView.sd_setImageWithURL(url)
            }
            else
            {
                print("invalid image url for product with name \(product.name)")
            }
            
            productNameLabel.text = product.name
        }
    }
    
}
