//
//  ViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 13/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ApiManager.sharedInstance.getPopularMovies { (list, error) in
            if let list = list {
                print(list)
            }
        }
        
        ApiManager.sharedInstance.getDetailsMovie(movieId: 320288) { (movie, error) in
            if let movie = movie {
                print(movie.title)
                print(movie.backdropPath)
                print(movie.imbdId) //NIL
                print(movie.overview)
                print(movie.posterPath)
                print(movie.releaseDate)
                print(movie.genres) //NIL
                print(movie.runtime)
            }
            
            if error != nil {
                print("error la concha de la madre")
            }
        }
        
        ApiManager.sharedInstance.getDetailsPerson(personId: 287) { (person, error) in
            if let person = person {
                print(person.name)
                print(person.biography)
                print(person.birthday)
                print(person.deathday)
                print(person.department)
                print(person.imbdId)
                print(person.placeOfBirth)
                print(person.profilePath)
            }
        }
    }


}

