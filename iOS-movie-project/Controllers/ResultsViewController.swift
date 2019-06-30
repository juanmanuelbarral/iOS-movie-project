//
//  ResultsViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 25/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!
    
    let apiManager = ApiManager.sharedInstance
    let collectionRowTopConstraint: Int = 10
    let collectionRowBottomConstraint: Int = 35
    var results: [String:[Any]] = [:]
    var categories: [String] = []
    var segueElement: Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
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
        apiManager.getDetailsPerson(personId: 1001657) { (person, error) in
            if let person = person {
                self.segueElement = person
                self.performSegue(withIdentifier: "fromResultsToPerson", sender: nil)
            }
        }
    }
}

extension ResultsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionRow") as! CollectionRowTableViewCell
        let category = categories[indexPath.section]
        switch category {
        case "Movies":
            let items = results[category] as! [MoviePreview]
            cell.configRow(
                items: items,
                itemWidth: MovieViewCell.Size.width.rawValue,
                itemHeight: MovieViewCell.Size.height.rawValue
            )
        case "People":
            let items = results[category] as! [PersonPreview]
            cell.configRow(
                items: items,
                itemWidth: PersonViewCell.Size.width.rawValue,
                itemHeight: PersonViewCell.Size.heightWithoutSub.rawValue
            )
            
        default:
            print("Items out of type on category: \(category) - index: \(indexPath.section)")
        }
        return cell
    }
}

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let category = categories[indexPath.section]
        var height: Int {
            switch category {
            case "Movies":
                return MovieViewCell.Size.height.rawValue
            
            case "People":
                return PersonViewCell.Size.heightWithoutSub.rawValue
            
            default:
                return 0
            }
        }
        
        return CGFloat(height + collectionRowTopConstraint + collectionRowBottomConstraint)
    }
}
