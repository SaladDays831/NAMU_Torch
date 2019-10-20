//
//  ArtDetailViewController.swift
//  NAMU_Torch
//
//  Created by Danil Kurilo on 18.10.2019.
//  Copyright © 2019 Danil Kurilo. All rights reserved.
//

import UIKit

class ArtDetailViewController: UIViewController {

    @IBOutlet weak var artName: UILabel!
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var artDescription: UITextView!
    @IBOutlet weak var artistYearLabel: UILabel!
    @IBOutlet weak var artHeightConstraint: NSLayoutConstraint!
    
    var descriptionText = ""
    var imageURL = ""
    var artNameText = ""
    var artistNameText = ""
    var artDateText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setImage()
        artDescription.text = descriptionText
        artName.text = "«\(artNameText)»"
        
    }
    
    
    func setImage() {
        artImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "leo"), completed: { (image, error, cacheType, imageURL) in
            let downImage = image as! UIImage
            //self.artImageHeight.constant = downImage.size.height
            let ratio = downImage.size.width / downImage.size.height
            let newHeight = self.artImageView.frame.width / ratio
            self.artHeightConstraint.constant = newHeight
            //self.artImageView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
        
    }
    

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
