//
//  Movie.swift
//  iOS-movie-project
//
//  Created by Manu on 16/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class Movie {
    
    var movieId: Int!
    var title: String?
    var posterPath: String?
    var backdropPath: String?
    var releaseDate: String?
    var runtime: Int?
    var genres: [String]?
    var overview: String?
    var imbdId: Int?
    var similarMovies: [MoviePreview]?
    
    required init?(map: Map) {
        if map.JSON[ApiConstants.MovieKeys.movieId] == nil { return nil }
    }
}

extension Movie: Mappable {
    
    func mapping(map: Map) {
        movieId <- map[ApiConstants.MovieKeys.movieId]
        title <- map[ApiConstants.MovieKeys.title]
        posterPath <- map[ApiConstants.MovieKeys.posterPath]
        backdropPath <- map[ApiConstants.MovieKeys.backdropPath]
        releaseDate <- map[ApiConstants.MovieKeys.releaseDate]
        runtime <- map[ApiConstants.MovieKeys.runtime]
//        genres <- map[]
        overview <- map[ApiConstants.MovieKeys.overview]
        imbdId <- map[ApiConstants.MovieKeys.imbdId]
    }
}
