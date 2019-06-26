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
    func performMultiSearch(query: String, onCompletion: @escaping ([String:Any]?, Error?) -> Void) {
        let queryFormatted = query.replacingOccurrences(of: " ", with: "%20")
        let url = "\(ApiManager.Config.baseUrl.rawValue)/search/multi?api_key=\(ApiManager.Config.apiKey.rawValue)&language=\(ApiManager.Config.language.rawValue)&query=\(queryFormatted)"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonResponse = value as! JsonType
                let resultsArray = jsonResponse["results"] as! [JsonType]
                var movieResults: [MoviePreview] = []
                var personResults: [PersonPreview] = []
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
                        
                    default:
                        print("Other type caught in the search of \(query)")
                    }
                }
                let returnDictionary: [String:Any] = [
                    "movie": movieResults,
                    "person": personResults
                ]
                onCompletion(returnDictionary, nil)
                
            case .failure(let error):
                onCompletion(nil, error)
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
        case profileSize = "/w185"
        case stillSize = "/w300"
        case imageNotFound = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAOVBMVEXz9Pa5vsq2u8jN0dnV2N/o6u7w8fTi5OnFydO+ws3f4ee6v8vY2+H29/jy9Pbu7/LJztbCx9HR1ty/NMEIAAAC8ElEQVR4nO3b67ZrMBiFYaSh1HHd/8XuFap1SFolXb7s8T4/18EwOyNCiSIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACryrezAy2kulR+lVl6dqip7Jr412Zyeizj7yjODjYqvhRQTMQm/1rC/OxsvapIht3xehDeN1lIOBSrtt+ZW+t1Kh02GrciEvaDNLl4Ph1e+hqvEk4Z94SZ580WchJGJNyHhH/JlrDR+uC+iU6Yqf7c2JXNga0KTlj/xOP5ujuwdpabML0mz1VXUu7eqtyEP5OAvysdvXerYhMWs4C/a+e9uyg1YXVdXh7sXTtLTagXFcaJ2rlVqQmXgzSOu5f76J5shSasylXC/NVJUbknW6kJLx8lNPNu6WhRaMKPRmmtzB+7WpSasNk+09TjmdPeotSEVbfs0HW7LFXjh2FvUWrC1Z1F1yCt1aRtW4tiE0ZqPk4dp4NUzYaypUW5CaNuGtExjdSLz8HSouCEjRqvnuLcceE/b9D+UQhOGFWZys093e7S2IfoqkFbi5ITRv1NDN24ds7SoKVF4QlfsTa4bjHchOmPI+AiYrgJXQ0uB2qoCWt3g4sWQ034qsF5i4EkbBY3ol43OGsxjIT6luvp7NG+DfhsMYSElc7jpHteAL85BhcthpBQ38zPny1uadD8x3C9JT+habD/RXdfu21rsP822fy5/IR9g/GjxXpjg+ZSKoiEY4OPFrc2GEzCR4O9XL87D4aWcNrgEHFzvkASzhv8UAAJVw3+dwkPNRhAwoMNBpDwYIPiEx5uUHzCww1KT1htX7qEmnD9/SEJSXhutgEJSUjC8/lOKPs+jfla7ajh/qPUhP6Q8C+RcJdKUML7W0HK75vA9+/hrmenM8bHgr/y7pqS8O7a43nEb7x/6Pvo3iddPa3njYx3SKMoO37rwu4mo8LIPJB4fLG2lggZoz3d5l6PQuPWahHTzEgXF79KQQUCAAAAAAAAAAAAAAAAAAAAAAAAAAAAp/gHLTI30QIHnooAAAAASUVORK5CYII="
    }
}
