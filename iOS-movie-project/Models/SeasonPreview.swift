//
//  SeasonPreview.swift
//  iOS-movie-project
//
//  Created by Manu on 2/7/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class SeasonPreview: Mappable {
    
//    var tvShowId: Int!
    var seasonNumber: Int!
    var name: String!
    var posterPath: String?
    var numberOfEpisodes: Int?
    
    
    required init?(map: Map) {
        if map.JSON[Keys.seasonNumber.rawValue] == nil { return nil }
        if map.JSON[Keys.name.rawValue] == nil { return nil }
    }
    
    func mapping(map: Map) {
        seasonNumber <- map[Keys.seasonNumber.rawValue]
        name <- map[Keys.name.rawValue]
        posterPath <- map[Keys.posterPath.rawValue]
        numberOfEpisodes <- map[Keys.numberOfEpisodes.rawValue]
    }
}

extension SeasonPreview {
    enum Keys: String {
        case seasonNumber = "season_number"
        case name
        case posterPath = "poster_path"
        case numberOfEpisodes = "episode_count"
    }
}
