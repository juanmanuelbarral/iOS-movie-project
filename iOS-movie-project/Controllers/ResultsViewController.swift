//
//  ResultsViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 25/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    var results: [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let movies = results["movie"] as? [MoviePreview]
        let people = results["person"] as? [PersonPreview]
        print(movies)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieVC = segue.destination as? MovieViewController {
            movieVC.movieId = 320288
        }
        
        if let personVC = segue.destination as? PersonViewController {
            personVC.personId = 1001657
        }
    }
    
    @IBAction func goToMovie(_ sender: Any) {
        performSegue(withIdentifier: "fromResultsToMovie", sender: nil)
    }
    
    @IBAction func goToPerson(_ sender: Any) {
        performSegue(withIdentifier: "fromResultsToPerson", sender: nil)
    }
}
