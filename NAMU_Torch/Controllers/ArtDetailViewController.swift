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
    @IBOutlet weak var artImageHeight: NSLayoutConstraint!
    @IBOutlet weak var artDescription: UITextView!
    @IBOutlet weak var artistYearLabel: UILabel!
    
    var descriptionText = ""
    var imageURL = ""
    var artNameText = ""
    var artistNameText = ""
    var artDateText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        artImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "leo"))
        artDescription.text = descriptionText
        artName.text = "«\(artNameText)»"
        
    }
    

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
