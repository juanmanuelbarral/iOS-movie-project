//
//  TvShowPreview.swift
//  iOS-movie-project
//
//  Created by Manu on 2/7/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class TvShowPreview: Mappable {
    
    var tvShowId: Int!
    var name: String!
    var posterPath: String?
    
    required init?(map: Map) {
        if map.JSON[TvShow.Keys.tvShowId.rawValue] == nil { return nil }
        if map.JSON[TvShow.Keys.name.rawValue] == nil { return nil }
    }
    
    func mapping(map: Map) {
        tvShowId <- map[TvShow.Keys.tvShowId.rawValue]
        name <- map[TvShow.Keys.name.rawValue]
        posterPath <- map[TvShow.Keys.posterPath.rawValue]
    }
}
