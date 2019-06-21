//
//  PersonPreview.swift
//  iOS-movie-project
//
//  Created by Manu on 16/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class PersonPreview {
    
    var personId: Int!
    var name: String?
    var profilePath: String!
    
    required init?(map: Map) {
        if map.JSON[Person.Keys.personId.rawValue] == nil { return nil }
        if map.JSON[Person.Keys.profilePath.rawValue] == nil {
            profilePath = ApiManager.Images.imageNotFound.rawValue
        }
    }
}

extension PersonPreview: Mappable {
    func mapping(map: Map) {
        personId <- map[Person.Keys.personId.rawValue]
        name <- map[Person.Keys.name.rawValue]
        profilePath <- map[Person.Keys.profilePath.rawValue]
    }
}
