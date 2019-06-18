//
//  ApiConstants.swift
//  iOS-movie-project
//
//  Created by Manu on 13/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

struct ApiConstants {
    
    static let apiKey = "a96994d867a6bbedf3fab3d61dda712c"
    static let baseUrl = "https://api.themoviedb.org/3"
    static let language = "en-US"
    
    struct Images {
        static let baseUrl = "https://image.tmdb.org/t/p"
        static let backdropSize = "w780"
        static let posterSize = "w500"
        static let profileSize = "w185"
        static let stillSize = "w300"
    }
    
    struct MovieKeys {
        static let movieId = "id"
        static let title = "title"
        static let posterPath = "poster_path"
        static let backdropPath = "backdrop_path"
        static let releaseDate = "release_date"
        static let runtime = "runtime"
        static let overview = "overview"
        static let genres = "genres.name"
        static let imbdId = "imdb_id"
        
        // MovieCredit
        static let character = "character"
        static let job = "job"
    }
    
    struct PersonKeys {
        static let personId = "id"
        static let name = "name"
        static let birthday = "birthday"
        static let deathday = "deathday"
        static let department = "known_for_department"
        static let biography = "biography"
        static let placeOfBirth = "place_of_birth"
        static let profilePath = "profile_path"
        static let imbdId = "imdb_id"
        
        // PersonCredit
        static let character = "character"
        static let job = "job"
    }
}
