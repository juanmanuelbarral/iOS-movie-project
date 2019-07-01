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
    
    private let headerHeight: Int = 30
    private let firstHeaderExtra: Int = 40
    private let collectionRowTopConstraint: Int = 10
    private let collectionRowBottomConstraint: Int = 35
    
    private let apiManager = ApiManager.sharedInstance
    var results: [String:[Any]] = [:]
    var categories: [String] = []
    private var segueItem: Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.register(UINib(nibName: "CollectionRowTableViewCell", bundle: nil), forCellReuseIdentifier: "collectionRow")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieViewController = segue.destination as? MovieViewController {
            movieViewController.movie = (segueItem as! Movie)
        }
        
        if let personViewController = segue.destination as? PersonViewController {
            personViewController.person = (segueItem as! Person)
        }
    }
}

extension ResultsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(headerHeight + firstHeaderExtra)
        } else {
            return CGFloat(headerHeight)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)?.first as! SectionHeaderView
        let titleForSection = categories[section]
        header.sectionTitleLabel.text = titleForSection
        return header
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
            cell.actionsDelegate = self
            cell.configRow(
                items: items,
                itemWidth: MovieViewCell.Size.width.rawValue,
                itemHeight: MovieViewCell.Size.height.rawValue
            )
        
        case "People":
            let items = results[category] as! [PersonPreview]
            cell.actionsDelegate = self
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

extension ResultsViewController: CollectionRowProtocol {
    func onMovieNavigation(movieId: Int) {
        apiManager.getDetailsMovie(movieId: movieId) { (movie, error) in
            if let movie = movie {
                self.segueItem = movie
                self.performSegue(withIdentifier: "fromResultsToMovie", sender: nil)
            }
            
            if let error = error {
                let alert = self.messageAlert(
                    title: "There was a problem with opening this movie",
                    message: "Check your connection to the internet and try again.\n\(error.localizedDescription)"
                )
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func onPersonNavigation(personId: Int) {
        apiManager.getDetailsPerson(personId: personId) { (person, error) in
            if let person = person {
                self.segueItem = person
                self.performSegue(withIdentifier: "fromResultsToPerson", sender: nil)
            }
            
            if let error = error {
                let alert = self.messageAlert(
                    title: "There was a problem with opening this person's information",
                    message: "Check your connection to the internet and try again.\n\(error.localizedDescription)"
                )
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
