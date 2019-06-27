//
//  Movie.swift
//  iOS-movie-project
//
//  Created by Manu on 16/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class Movie: Mappable {
    
    var movieId: Int!
    var title: String!
    var posterPath: String!
    var backdropPath: String?
    var releaseDate: String?
    var runtime: Int?
    var genres: [String]?
    var overview: String?
    var imbdId: String?
    
    required init?(map: Map) {
        if map.JSON[Keys.movieId.rawValue] == nil { return nil }
        if map.JSON[Keys.title.rawValue] == nil { return nil }
    }
    
    func mapping(map: Map) {
        movieId <- map[Keys.movieId.rawValue]
        title <- map[Keys.title.rawValue]
        posterPath <- map[Keys.posterPath.rawValue]
        backdropPath <- map[Keys.backdropPath.rawValue]
        releaseDate <- map[Keys.releaseDate.rawValue]
        runtime <- map[Keys.runtime.rawValue]
//        genres <- map[Keys.genres.rawValue]
        overview <- map[Keys.overview.rawValue]
        imbdId <- map[Keys.imbdId.rawValue]
    }
}

extension Movie {
    enum Keys: String {
        case movieId = "id"
        case title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case runtime
        case overview
        case genres
        case imbdId = "imdb_id"
    }
}
