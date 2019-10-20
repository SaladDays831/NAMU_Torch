//
//  ArtObject.swift
//  NAMU_Torch
//
//  Created by Danil Kurilo on 9/29/19.
//  Copyright © 2019 Danil Kurilo. All rights reserved.
//


import Foundation

struct RootClass : Codable {

        let rows : [ArtObject]?

        enum CodingKeys: String, CodingKey {
                case rows = "rows"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                rows = try values.decodeIfPresent([ArtObject].self, forKey: .rows)
        }

}

struct ArtObject : Codable {
    
    let id : Int?
    let image : String?
    let name : String?
    let authoryear : String?
    let nextconnection : String?
    let trigger1description : String?
    let trigger1name : String?
    let trigger2description : String?
    let trigger2name : String?
    let trigger3description : String?
    let trigger3name : String?
    let trigger4description : String?
    let trigger4name : String?
    let trigger5description : String?
    let trigger5name : String?
    
    enum CodingKeys: String, CodingKey {
                case id = "id"
                case image = "image"
                case name = "name"
                case authoryear = "authoryear"
                case nextconnection = "nextconnection"
                case trigger1description = "trigger1description"
                case trigger1name = "trigger1name"
                case trigger2description = "trigger2description"
                case trigger2name = "trigger2name"
                case trigger3description = "trigger3description"
                case trigger3name = "trigger3name"
                case trigger4description = "trigger4description"
                case trigger4name = "trigger4name"
                case trigger5description = "trigger5description"
                case trigger5name = "trigger5name"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                image = try values.decodeIfPresent(String.self, forKey: .image)
                name = try values.decodeIfPresent(String.self, forKey: .name)
                authoryear = try values.decodeIfPresent(String.self, forKey: .authoryear)
                nextconnection = try values.decodeIfPresent(String.self, forKey: .nextconnection)
                trigger1description = try values.decodeIfPresent(String.self, forKey: .trigger1description)
                trigger1name = try values.decodeIfPresent(String.self, forKey: .trigger1name)
                trigger2description = try values.decodeIfPresent(String.self, forKey: .trigger2description)
                trigger2name = try values.decodeIfPresent(String.self, forKey: .trigger2name)
                trigger3description = try values.decodeIfPresent(String.self, forKey: .trigger3description)
                trigger3name = try values.decodeIfPresent(String.self, forKey: .trigger3name)
                trigger4description = try values.decodeIfPresent(String.self, forKey: .trigger4description)
                trigger4name = try values.decodeIfPresent(String.self, forKey: .trigger4name)
                trigger5description = try values.decodeIfPresent(String.self, forKey: .trigger5description)
                trigger5name = try values.decodeIfPresent(String.self, forKey: .trigger5name)
        }
    
}

