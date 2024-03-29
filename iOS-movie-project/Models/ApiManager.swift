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
    
    // MULTI SEARCH
    // https://api.themoviedb.org/3/search/multi?api_key=<<api_key>>&language=en-US&query=<<query>>
    func performMultiSearch(query: String, onCompletion: @escaping ([String:[Any]]?, [String]?, Error?) -> Void) {
        let queryFormatted = query.replacingOccurrences(of: " ", with: "%20")
        let url = "\(ApiManager.Config.baseUrl.rawValue)/search/multi?api_key=\(ApiManager.Config.apiKey.rawValue)&language=\(ApiManager.Config.language.rawValue)&query=\(queryFormatted)"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonResponse = value as! JsonType
                let resultsArray = jsonResponse["results"] as! [JsonType]
                var movieResults: [MoviePreview] = []
                var personResults: [PersonPreview] = []
                var tvShowResults: [TvShowPreview] = []
                resultsArray.forEach{ (result) in
                    let type = result["media_type"] as! String
                    switch type {
                    case "movie":
                        if let moviePreview = Mapper<MoviePreview>().map(JSON: result) {
                            movieResults.append(moviePreview)
                        }
                        
                    case "person":
                        if let personPreview = Mapper<PersonPreview>().map(JSON: result) {
                            personResults.append(personPreview)
                        }
                        
                    case "tv":
                        if let tvShowPreview = Mapper<TvShowPreview>().map(JSON: result) {
                            tvShowResults.append(tvShowPreview)
                        }
                        
                    default:
                        print("Other type caught in the search of \(query)")
                    }
                }
                let returnDictionary: [String:[Any]] = [
                    "Movies": movieResults,
                    "Tv Shows": tvShowResults,
                    "People": personResults
                ]
                let returnCategories = ["Movies", "Tv Shows", "People"]
                
                onCompletion(returnDictionary, returnCategories, nil)
                
            case .failure(let error):
                onCompletion(nil, nil, error)
            }
        }
    }
    
    // GET POPULAR MOVIES
    // https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1
    func getPopularMovies(onCompletion: @escaping ([MoviePreview]?, Error?) -> Void) {
        let url = "\(Config.baseUrl.rawValue)/movie/popular?api_key=\(Config.apiKey.rawValue)&language=\(Config.language.rawValue)&page=1"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonResponse = value as! JsonType
                let previewsArray = jsonResponse["results"] as! [JsonType]
                let moviePreviews: [MoviePreview] = Mapper<MoviePreview>().mapArray(JSONArray: previewsArray)
                onCompletion(moviePreviews, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    
    // GET MOVIE DETAILS
    // https://api.themoviedb.org/3/movie/{movie_id}?api_key=<<api_key>>&language=en-US
    func getDetailsMovie(movieId: Int, onCompletion: @escaping (Movie?, Error?) -> Void) {
        let url = "\(Config.baseUrl.rawValue)/movie/\(movieId)?api_key=\(Config.apiKey.rawValue)&language=\(Config.language.rawValue)"
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
    func getMovieCredits(movieId: Int, onCompletion: @escaping ([Member.Role:[Member]]?, Error?) -> Void) {
        let url = "\(Config.baseUrl.rawValue)/movie/\(movieId)/credits?api_key=\(Config.apiKey.rawValue)"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonResponse = value as! JsonType
                let castArray = jsonResponse["cast"] as! [JsonType]
                var castMembers: [CastMember] = []
                castArray.forEach { (castItem) in
                    if let castMember = Mapper<CastMember>().map(JSON: castItem) {
                        castMember.mediaId = movieId
                        castMembers.append(castMember)
                    }
                }
                
                let crewArray = jsonResponse["crew"] as! [JsonType]
                var crewMembers: [CrewMember] = []
                crewArray.forEach { (crewItem) in
                    if let crewMember = Mapper<CrewMember>().map(JSON: crewItem) {
                        crewMember.mediaId = movieId
                        crewMembers.append(crewMember)
                    }
                }
                
                let members: [Member.Role:[Member]] = [
                    Member.Role.cast: castMembers,
                    Member.Role.crew: crewMembers
                ]
                onCompletion(members, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    
    // GET SIMILAR MOVIES
    // https://api.themoviedb.org/3/movie/{movie_id}/similar?api_key=<<api_key>>&language=en-US&page=1
    func getSimilarMovies(movieId: Int, onCompletion: @escaping ([MoviePreview]?, Error?) -> Void) {
        let url = "\(Config.baseUrl.rawValue)/movie/\(movieId)/similar?api_key=\(Config.apiKey.rawValue)&language=\(Config.language.rawValue)&page=1"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonResponse = value as! JsonType
                let moviesArray = jsonResponse["results"] as! [JsonType]
                let similarMovies = Mapper<MoviePreview>().mapArray(JSONArray: moviesArray)
                onCompletion(similarMovies, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    
    // GET PERSON DETAILS
    // https://api.themoviedb.org/3/person/{person_id}?api_key=<<api_key>>&language=en-US
    func getDetailsPerson(personId: Int, onCompletion: @escaping (Person?, Error?) -> Void) {
        let url = "\(Config.baseUrl.rawValue)/person/\(personId)?api_key=\(Config.apiKey.rawValue)&language=\(Config.language.rawValue)"
        Alamofire.request(url).responseObject { (response: DataResponse<Person>) in
            switch response.result {
            case .success(let person):
                onCompletion(person, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    
    // GET PERSON'S MOVIE CREDITS
    // https://api.themoviedb.org/3/person/{person_id}/movie_credits?api_key=<<api_key>>&language=en-US
    func getMovieCreditsPerson(personId: Int, onCompletion: @escaping ([Participation.Role:[Participation]]?, Error?) -> Void) {
        let url = "\(Config.baseUrl.rawValue)/person/\(personId)/movie_credits?api_key=\(Config.apiKey.rawValue)&language=\(Config.language.rawValue)"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonResponse = value as! JsonType
                let asCastArray = jsonResponse["cast"] as! [JsonType]
                var participationsCast: [ParticipationAsCast] = []
                asCastArray.forEach { (participation) in
                    if let participationCast = Mapper<ParticipationAsCast>().map(JSON: participation) {
                        participationCast.personId = personId
                        participationsCast.append(participationCast)
                    }
                }
                
                let asCrewArray = jsonResponse["crew"] as! [JsonType]
                var participationsCrew: [ParticipationAsCrew] = []
                asCrewArray.forEach{ (participation) in
                    if let participationCrew = Mapper<ParticipationAsCrew>().map(JSON: participation) {
                        participationCrew.personId = personId
                        participationsCrew.append(participationCrew)
                    }
                }
                
                let participations: [Participation.Role:[Participation]] = [
                    Participation.Role.cast: participationsCast,
                    Participation.Role.crew: participationsCrew
                ]
                onCompletion(participations, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    
    // GET POPULAR TV SHOWS
    // https://api.themoviedb.org/3/tv/popular?api_key=<<api_key>>&language=en-US&page=1
    func getPopularTvShows(onCompletion: @escaping ([TvShowPreview]?, Error?) -> Void) {
        let url = "\(Config.baseUrl.rawValue)/tv/popular?api_key=\(Config.apiKey.rawValue)&language=\(Config.language.rawValue)&page=1"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonResponse = value as! JsonType
                let previewsArray = jsonResponse["results"] as! [JsonType]
                let tvShowPreviews: [TvShowPreview] = Mapper<TvShowPreview>().mapArray(JSONArray: previewsArray)
                onCompletion(tvShowPreviews, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    
    // GET TV SHOW DETAILS
    // https://api.themoviedb.org/3/tv/{tv_id}?api_key=<<api_key>>&language=en-US
    func getDetailsTvShow(tvShowId: Int, onCompletion: @escaping (TvShow?, Error?) -> Void) {
        let url = "\(Config.baseUrl.rawValue)/tv/\(tvShowId)?api_key=\(Config.apiKey.rawValue)&language=\(Config.language.rawValue)"
        Alamofire.request(url).responseObject { (response: DataResponse<TvShow>) in
            switch response.result {
            case .success(let tvShow):
                onCompletion(tvShow, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    
    // GET TV SHOW CREDITS
    // https://api.themoviedb.org/3/tv/{tv_id}/credits?api_key=<<api_key>>&language=en-US
    func getTvShowCredits(tvShowId: Int, onCompletion: @escaping ([Member.Role:[Member]]?, Error?) -> Void) {
        let url = "\(Config.baseUrl.rawValue)/tv/\(tvShowId)/credits?api_key=\(Config.apiKey.rawValue)&language=\(Config.language.rawValue)"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonResponse = value as! JsonType
                let castArray = jsonResponse["cast"] as! [JsonType]
                var castMembers: [CastMember] = []
                castArray.forEach { (castItem) in
                    if let castMember = Mapper<CastMember>().map(JSON: castItem) {
                        castMember.mediaId = tvShowId
                        castMembers.append(castMember)
                    }
                }
                
                let crewArray = jsonResponse["crew"] as! [JsonType]
                var crewMembers: [CrewMember] = []
                crewArray.forEach { (crewItem) in
                    if let crewMember = Mapper<CrewMember>().map(JSON: crewItem) {
                        crewMember.mediaId = tvShowId
                        crewMembers.append(crewMember)
                    }
                }
                
                let members: [Member.Role:[Member]] = [
                    Member.Role.cast: castMembers,
                    Member.Role.crew: crewMembers
                ]
                onCompletion(members, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    
    // GET SIMILAR TV SHOWS
    // https://api.themoviedb.org/3/tv/{tv_id}/similar?api_key=<<api_key>>&language=en-US&page=1
    func getSimilarTvShows(tvShowId: Int, onCompletion: @escaping ([TvShowPreview]?, Error?) -> Void) {
        let url = "\(Config.baseUrl.rawValue)/tv/\(tvShowId)/similar?api_key=\(Config.apiKey.rawValue)&language=\(Config.language.rawValue)&page=1"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonResponse = value as! JsonType
                let previewsArray = jsonResponse["results"] as! [JsonType]
                let similarTvShows = Mapper<TvShowPreview>().mapArray(JSONArray: previewsArray)
                onCompletion(similarTvShows, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    
    // GET PERSON'S TV SHOW CREDITS
    // https://api.themoviedb.org/3/person/{person_id}/tv_credits?api_key=<<api_key>>&language=en-US
    func getTvShowCreditsPerson(personId: Int, onCompletion: @escaping ([Participation.Role:[Participation]]?, Error?) -> Void) {
        let url = "\(Config.baseUrl.rawValue)/person/\(personId)/tv_credits?api_key=\(Config.apiKey.rawValue)&language=\(Config.language.rawValue)"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonResponse = value as! JsonType
                let asCastArray = jsonResponse["cast"] as! [JsonType]
                var participationsCast: [ParticipationAsCast] = []
                asCastArray.forEach { (participation) in
                    if let participationCast = Mapper<ParticipationAsCast>().map(JSON: participation) {
                        participationCast.personId = personId
                        participationsCast.append(participationCast)
                    }
                }
                
                let asCrewArray = jsonResponse["crew"] as! [JsonType]
                var participationsCrew: [ParticipationAsCrew] = []
                asCrewArray.forEach{ (participation) in
                    if let participationCrew = Mapper<ParticipationAsCrew>().map(JSON: participation) {
                        participationCrew.personId = personId
                        participationsCrew.append(participationCrew)
                    }
                }
                
                let participations: [Participation.Role:[Participation]] = [
                    Participation.Role.cast: participationsCast,
                    Participation.Role.crew: participationsCrew
                ]
                onCompletion(participations, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    
    // (HARCODED) GET STREAMING PLATFORMS
    func getStreamingPlatforms(quantity: Int, onCompletion: @escaping ([Bool]) -> Void) {
        var result: [Bool] = []
        for _ in 1...quantity {
            let value = Bool.random()
            result.append(value)
        }
        onCompletion(result)
    }
}

extension ApiManager {
    
    typealias JsonType = [String:Any]
    
    enum Config: String {
        case apiKey = "a96994d867a6bbedf3fab3d61dda712c"
        case baseUrl = "https://api.themoviedb.org/3"
        case language = "en-US"
    }
    
    enum Images: String {
        case baseUrl = "https://image.tmdb.org/t/p"
        case backdropSize = "/w780"
        case posterSize = "/w500"
        case profileSize = "/h632"
        case stillSize = "/w300"
        case imageNotFound = "https://images.immediate.co.uk/production/volatile/sites/3/2017/11/imagenotavailable1-39de324.png?quality=90&resize=768,574"
    }
}
