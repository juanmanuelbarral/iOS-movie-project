//
//  Participation.swift
//  iOS-movie-project
//
//  Created by Manu on 20/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class Participation: Mappable {
    
    var personId: Int!
    var mediaId: Int!
    var title: String?
    var posterPath: String!
    
    required init?(map: Map) {
        if map.JSON[Keys.mediaId.rawValue] == nil { return nil }
        if map.JSON[Keys.posterPath.rawValue] == nil {
            posterPath = ApiManager.Images.imageNotFound.rawValue
        }
    }
    
    func mapping(map: Map) {
        mediaId <- map[Keys.mediaId.rawValue]
        title <- map[Keys.title.rawValue]
        posterPath <- map[Keys.posterPath.rawValue]
    }
}

extension Participation {
    enum Keys: String {
        case mediaId = "id"
        case title = "title"
        case posterPath = "poster_path"
        case character = "character"
        case job = "job"
    }
    
    enum Role {
        case cast
        case crew
    }
}
