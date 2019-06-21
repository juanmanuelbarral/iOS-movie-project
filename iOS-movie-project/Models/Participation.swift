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
    var posterPath: String?
    
    required init?(map: Map) {
        if map.JSON[ApiConstants.MovieKeys.movieId] == nil { return nil }
        if map.JSON[ApiConstants.MovieKeys.posterPath] == nil {
            posterPath = ApiConstants.Images.imageNotFound
        }
    }
    
    func mapping(map: Map) {
        mediaId <- map[ApiConstants.MovieKeys.movieId]
        title <- map[ApiConstants.MovieKeys.title]
        posterPath <- map[ApiConstants.MovieKeys.posterPath]
    }
}
