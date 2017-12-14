//
//  Repository.swift
//  UserTracker
//
//  Created by Carlos Cortés Sánchez on 14/12/2017.
//  Copyright © 2017 Carlos Cortés Sánchez. All rights reserved.
//

import ObjectMapper

class Repository: Mappable {
    var identifier: Int!
    var language: String!
    var url: String!
    var name: String!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        identifier <- map["id"]
        language <- map["language"]
        url <- map["url"]
        name <- map["name"]
    }
}
