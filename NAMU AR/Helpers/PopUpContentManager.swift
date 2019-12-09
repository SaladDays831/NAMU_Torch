//
//  PopUpContentManager.swift
//  NAMU_Torch
//
//  Created by Danil Kurilo on 10/1/19.
//  Copyright © 2019 Danil Kurilo. All rights reserved.
//

import UIKit

var artObjects = [ArtObject]()

class PopUpContentManager {
    
    private init() {}
    static let shared = PopUpContentManager()
    
    //var artObjects = [ArtObject]()
  
    
    func loadData() {
        
        guard let url = URL(string: "http://gsx2json.com/api?id=1f7j3WPBouLWuIhySO2p2bFF13RlR76BxvLSNFUT9Ods&columns=false") else {
            print("RETURNED")
            return }
        //http://gsx2json.com/api?id=11tvOkkWUcaYtmk5nVNOzMNx4v19VnhYuIqjC60zVrSw&sheet=1&columns=false
        URLSession.shared.dataTask(with: url) { (data, response
                 , error) in
                 guard let data = data else {
                    print("RETURNED")
                    return }
    
                 do {
                     let decoder = JSONDecoder()
                    let rows = try decoder.decode(RootClass.self, from: data)
                    guard let JSONArt = rows.rows else { return }
                    artObjects = JSONArt
                    print("artObjects has \(artObjects.count) items")
                 } catch let error {
                     print("Error: ", error)
              }
        }.resume()
        
    }
    
}
