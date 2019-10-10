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
        
        guard let url = URL(string: "https://script.google.com/macros/s/AKfycbwi_FubE4jHNfe9lGQDB58fyYh-jz1byPn45a5qdLJotqGBbFGn/exec") else {
            print("RETURNED HERE?????")
            return }
        URLSession.shared.dataTask(with: url) { (data, response
                 , error) in
                 guard let data = data else {
                    print("RETURNED")
                    return }
    
                 do {
                     let decoder = JSONDecoder()
                    artObjects = try decoder.decode([ArtObject].self, from: data)
                    print("artObjects has \(artObjects.count) items")
                    //print("\(artObjects[0].trigger1Description)")
                 } catch let error {
                     print("Error: ", error)
              }
        }.resume()
        
    }
    
    

    
    
    
    
}
