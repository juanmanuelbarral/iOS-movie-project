//
//  ResultsViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 25/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    let apiManager = ApiManager.sharedInstance
    var results: [String:Any] = [:]
    var segueElement: Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieVC = segue.destination as? MovieViewController {
            movieVC.movie = (segueElement as! Movie)
        }
        
        if let personVC = segue.destination as? PersonViewController {
            personVC.person = (segueElement as! Person)
        }
    }
    
    @IBAction func goToMovie(_ sender: Any) {
        apiManager.getDetailsMovie(movieId: 320288) { (movie, error) in
            if let movie = movie {
                self.segueElement = movie
                self.performSegue(withIdentifier: "fromResultsToMovie", sender: nil)
            }
        }
    }
    
    @IBAction func goToPerson(_ sender: Any) {
        performSegue(withIdentifier: "fromResultsToPerson", sender: nil)
        apiManager.getDetailsPerson(personId: 1001657) { (person, error) in
            if let person = person {
                self.segueElement = person
                self.performSegue(withIdentifier: "fromResultsToPerson", sender: nil)
            }
        }
    }
}
