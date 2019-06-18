//
//  ApiManager.swift
//  iOS-movie-project
//
//  Created by Manu on 13/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ApiManager {
    
    //Singleton property
    static let sharedInstance = ApiManager()
    
    private init() {}
    
    // GET POPULAR MOVIES
    // https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1
    func getPopularMovies(onCompletion: @escaping ([MoviePreview]?, Error?) -> Void) {
        let url = "\(ApiConstants.baseUrl)/movie/popular?api_key=\(ApiConstants.apiKey)&language=\(ApiConstants.language)&page=1"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonResponse = value as! [String:Any]
                let previewsArray = jsonResponse["results"] as! [[String:Any]]
                let moviePreviews: [MoviePreview] = Mapper<MoviePreview>().mapArray(JSONArray: previewsArray)
//                var moviePreviews: [Int:MoviePreview] = [:]
//                previewsArray.forEach{ (preview) in
//                    if let moviePreview = Mapper<MoviePreview>().map(JSON: preview) {
//                        moviePreviews.updateValue(moviePreview, forKey: moviePreview.movieId)
//                    }
//                }
                onCompletion(moviePreviews, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    // GET MOVIE DETAILS
    // https://api.themoviedb.org/3/movie/{movie_id}?api_key=<<api_key>>&language=en-US
    func getDetailsMovie(movieId: Int, onCompletion: @escaping (Movie?, Error?) -> Void) {
        let url = "\(ApiConstants.baseUrl)/movie/\(movieId)?api_key=\(ApiConstants.apiKey)&language=\(ApiConstants.language)"
        Alamofire.request(url).responseObject { (response: DataResponse<Movie>) in
            switch response.result {
            case .success(let movie):
                onCompletion(movie, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
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
