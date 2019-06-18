//
//  MoviePreview.swift
//  iOS-movie-project
//
//  Created by Manu on 16/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class MoviePreview {
    
    var movieId: Int!
    var title: String?
    var posterPath: String?
    
    required init?(map: Map) {
        if map.JSON[ApiConstants.MovieKeys.movieId] == nil { return nil }
    }
}

extension MoviePreview: Mappable {
    func mapping(map: Map) {
        movieId <- map[ApiConstants.MovieKeys.movieId]
        title <- map[ApiConstants.MovieKeys.title]
        posterPath <- map[ApiConstants.MovieKeys.posterPath]
    }
}
