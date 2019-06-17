//
//  Movie.swift
//  iOS-movie-project
//
//  Created by Manu on 16/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

class Movie {
    
    var id: Int!
    var title: String?
    var releaseDate: String?
    var runtime: Int?
    var posterPath: String?
    var backdropPath: String?
//    var genres: [something]?
    var overview: String?
    var imbdId: Int?
    var similarMovies: [MoviePreview]?
}
