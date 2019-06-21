//
//  Member.swift
//  iOS-movie-project
//
//  Created by Manu on 20/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class Member: Mappable {
    
    var mediaId: Int!
    var personId: Int!
    var name: String?
    var profilePath: String?
    
    required init?(map: Map) {
        if map.JSON[Keys.personId.rawValue] == nil { return nil }
        if map.JSON[Keys.profilePath.rawValue] == nil {
            profilePath = ApiManager.Images.imageNotFound.rawValue
        }
    }
    
    func mapping(map: Map) {
        personId <- map[Keys.personId.rawValue]
        name <- map[Keys.name.rawValue]
        profilePath <- map[Keys.profilePath.rawValue]
    }
}

extension Member {
    enum Keys: String {
        case personId = "id"
        case name
        case profilePath = "profile_path"
        case character
        case job
    }
    
    enum Role: String {
        case cast
        case crew
    }
}
