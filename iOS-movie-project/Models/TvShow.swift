//
//  TvShow.swift
//  iOS-movie-project
//
//  Created by Manu on 2/7/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class TvShow: Mappable {
    
    var tvShowId: Int!
    var name: String!
    var posterPath: String?
    var backdropPath: String?
    var firstAirDate: Date?
    var lastAirDate: Date?
    var status: String?
    var numberOfSeasons: Int?
    var numberOfEpisodes: Int?
    var runtime: [Int]?
    var overview: String?
//    var seasons: [SeasonPreview]?
    
    required init?(map: Map) {
        if map.JSON[Keys.tvShowId.rawValue] == nil { return nil }
        if map.JSON[Keys.name.rawValue] == nil { return nil }
    }
    
    func mapping(map: Map) {
        tvShowId <- map[Keys.tvShowId.rawValue]
        name <- map[Keys.name.rawValue]
        posterPath <- map[Keys.posterPath.rawValue]
        backdropPath <- map[Keys.backdropPath.rawValue]
        firstAirDate <- map[Keys.firstAirDate.rawValue]
        lastAirDate <- map[Keys.lastAirDate.rawValue]
        status <- map[Keys.status.rawValue]
        numberOfSeasons <- map[Keys.numberOfSeasons.rawValue]
        numberOfEpisodes <- map[Keys.numberOfEpisodes.rawValue]
        runtime <- map[Keys.runtime.rawValue]
        overview <- map[Keys.overview.rawValue]
        //    seasons <- map[Keys.seasons.rawValue]
    }
}

extension TvShow {
    enum Keys: String {
        case tvShowId = "id"
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case status
        case numberOfSeasons = "number_of_seasons"
        case numberOfEpisodes = "number_of_episodes"
        case runtime = "episode_run_time"
        case overview
        //    case seasons
    }
}
