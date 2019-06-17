//
//  ApiManager.swift
//  iOS-movie-project
//
//  Created by Manu on 13/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

class ApiManager {
    
    //Singleton property
    static let sharedInstance = ApiManager()
    
    private init() {}
    
    // GET POPULAR MOVIES
    // https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1
    func getPopularMovies() {
        // TODO: implement
    }
    
    // GET MOVIE DETAILS
    // https://api.themoviedb.org/3/movie/{movie_id}?api_key=<<api_key>>&language=en-US
    func getDetailsMovie(movieId: Int) {
        // TODO: implement
    }
    
    // GET MOVIE CREDITS
    // https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key=<<api_key>>
    func getCreditsMovie(movieId: Int) {
        // TODO: implement
    }
    
    // GET SIMILAR MOVIES
    // https://api.themoviedb.org/3/movie/{movie_id}/similar?api_key=<<api_key>>&language=en-US&page=1
    func getSimilarMovies(movieId: Int) {
        // TODO: implement
    }
    
    // GET PERSON DETAILS
    // https://api.themoviedb.org/3/person/{person_id}?api_key=<<api_key>>&language=en-US
    func getDetailsPerson(personId: Int) {
        // TODO: implement
    }
    
    // GET PERSONS MOVIE CREDITS
    // https://api.themoviedb.org/3/person/{person_id}/movie_credits?api_key=<<api_key>>&language=en-US
    func getMovieCreditsPerson(personId: Int) {
        // TODO: implement
    }
    
//    // GET PERSONS TV CREDITS
//    // https://api.themoviedb.org/3/person/{person_id}/tv_credits?api_key=<<api_key>>&language=en-US
//    func getTvCreditsPerson(personId: Int) {
//        // TODO: implement
//    }
}
