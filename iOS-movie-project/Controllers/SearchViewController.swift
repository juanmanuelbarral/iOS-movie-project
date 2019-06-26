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
    
    let apiManager = ApiManager.sharedInstance
    var searchIsActive: Bool = false
    var searchText: String = ""
    var results: [String: Any]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultsVC = segue.destination as? ResultsViewController {
            resultsVC.results = self.results
        }
    }
    
    @IBAction func onTouchSearchButton(_ sender: Any) {
        //performSegue(withIdentifier: "fromSearchToResults", sender: nil)
        if searchIsActive {
            apiManager.performMultiSearch(query: searchText) { (results: [String : Any]?, error: Error?) in
                if let results = results {
                    self.results = results
                    self.performSegue(withIdentifier: "fromSearchToResults", sender: nil)
                }
            }
        } else {
            // TODO: show a message "Type in something!" or sth like that
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Check if there is text in the search bar to filter items
        if searchText == "" {
            searchIsActive = false
        } else {
            searchIsActive = true
        }
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
