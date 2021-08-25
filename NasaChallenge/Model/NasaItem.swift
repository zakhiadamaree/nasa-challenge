//
//  NasaItem.swift
//  NasaChallenge
//
//  Created by Zakhia Damaree on 19/08/2021.
//  Copyright © 2021 Zakhia Damaree. All rights reserved.
//

import Foundation

struct NasaItem: Codable {
    var collection: Collection
    
    struct Collection: Codable {
        let items: [Item]
    }
    
    struct Item: Codable {
        let data: [DataItem]
        let href: String
        let links: [Link]
    }
    
    struct DataItem: Codable {
        let name: String?
        let title: String?
        let description: String?
        let dateCreated: Date?
        
        enum CodingKeys: String, CodingKey {
            case name = "photographer"
            case dateCreated = "date_created"
            case title, description
        }
    }
    
    struct Link: Codable {
        let href: String
    }
}
