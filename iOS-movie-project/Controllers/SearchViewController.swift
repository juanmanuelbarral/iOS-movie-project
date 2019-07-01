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
    var segueResults: [String: [Any]] = [:]
    var segueCategories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultsViewController = segue.destination as? ResultsViewController {
            resultsViewController.results = self.segueResults
            resultsViewController.categories = self.segueCategories
        }
    }
    
    @IBAction func onTouchSearchButton(_ sender: Any) {
        if searchIsActive {
            apiManager.performMultiSearch(query: searchText) { (results: [String : [Any]]?, categories: [String]?, error: Error?) in
                if let results = results {
                    self.segueResults = results
                    self.segueCategories = categories!
                    self.performSegue(withIdentifier: "fromSearchToResults", sender: nil)
                }
                
                if let error = error {
                    let alert = self.messageAlert(
                        title: "Oops! there was a problem with your search",
                        message: "Check your connection to the internet and try again.\n\(error.localizedDescription)"
                    )
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let alert = self.messageAlert(
                title: "Empty search",
                message: "Enter something to search for in the search bar!"
            )
            self.present(alert, animated: true, completion: nil)
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
