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
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        if let artURL = row.image {
            cell.artImageView.sd_setImage(with: URL(string: artURL), placeholderImage: UIImage(named: "leo"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArtDetailViewController") as? ArtDetailViewController
        
        
        let rawTexts = [artObjects[indexPath.row].trigger1description, artObjects[indexPath.row].trigger2description, artObjects[indexPath.row].trigger3description, artObjects[indexPath.row].trigger4description, artObjects[indexPath.row].trigger5description]
        
        var description = ""
        for item in rawTexts {
            if item != "nil" {
                description = description + " " + item!
            }
        }
        
        vc?.artNameText = artObjects[indexPath.row].name!
        vc?.descriptionText = description
        vc?.imageURL = artObjects[indexPath.row].image!
        vc?.author_yearText = artObjects[indexPath.row].authoryear!
       
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc!, animated: true)
    
    }
    
}
