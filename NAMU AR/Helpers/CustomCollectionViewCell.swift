//
//  CustomCollectionViewCell.swift
//  NAMU_Torch
//
//  Created by Danil Kurilo on 9/26/19.
//  Copyright © 2019 Danil Kurilo. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var artImageView: UIImageView!
    
    override func prepareForReuse() {
      super.prepareForReuse()
      self.artImageView.sd_cancelCurrentImageLoad()
      self.artImageView.image = UIImage(named: "leo") // set to default/placeholder image
    }
    
    
    /*
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
      return layoutAttributes
    }
 
 */
}
