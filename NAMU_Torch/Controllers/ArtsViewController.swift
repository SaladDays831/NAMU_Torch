//
//  ArtsViewController.swift
//  NAMU_Torch
//
//  Created by Danil Kurilo on 9/26/19.
//  Copyright © 2019 Danil Kurilo. All rights reserved.
//

import UIKit
import SDWebImage

class ArtsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let popUpContentManager = PopUpContentManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

 
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension ArtsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = artObjects[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CustomCollectionViewCell
        
        if let artURL = row.image {
            print("YES THIS IS FUCKING ART")
            //cell.artImageView.sd_setImage(with: URL(string: artURL), placeholderImage: UIImage(named: "leo"))
            cell.artImageView.image = UIImage(named: "leo")
        }
        
        return cell
    }
    
    
}
