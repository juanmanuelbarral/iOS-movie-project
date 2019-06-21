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
    var posterPath: String!
    
    required init?(map: Map) {
        if map.JSON[Movie.Keys.movieId.rawValue] == nil { return nil }
        if map.JSON[Movie.Keys.posterPath.rawValue] == nil {
            posterPath = ApiManager.Images.imageNotFound.rawValue
        }
    }
}

extension MoviePreview: Mappable {
    func mapping(map: Map) {
        movieId <- map[Movie.Keys.movieId.rawValue]
        title <- map[Movie.Keys.title.rawValue]
        posterPath <- map[Movie.Keys.posterPath.rawValue]
    }
}
