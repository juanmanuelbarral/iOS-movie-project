//
//  SearchViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 24/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // maybe will use
    }
    
    @IBAction func onTouchSearchButton(_ sender: Any) {
        performSegue(withIdentifier: "fromSearchToResults", sender: nil)
    }
}
