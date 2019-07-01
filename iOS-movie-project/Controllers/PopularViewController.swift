//
//  PopularViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 25/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController {
    
    @IBOutlet weak var popularTableView: UITableView!
    
    private let headerHeight: Int = 30
    private let firstHeaderExtra: Int = 40
    private let minSpacing: Int = 10
    private let collectionRowTopConstraint: Int = 10
    private let collectionRowBottomConstraint: Int = 35
    
    private let apiManager = ApiManager.sharedInstance
    let categories = ["Movies"]
    var popularMovies: [MoviePreview] = []
    private var segueItem: Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popularTableView.dataSource = self
        popularTableView.delegate = self
        popularTableView.register(UINib(nibName: "CollectionRowTableViewCell", bundle: nil), forCellReuseIdentifier: "collectionRow")
        
        loadPopularMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieViewController = segue.destination as? MovieViewController {
            movieViewController.movie = (segueItem as! Movie)
        }
    }
    
    private func loadPopularMovies() {
        apiManager.getPopularMovies { (movies, error) in
            if let movies = movies {
                self.popularMovies = movies
                self.popularTableView.reloadData()
            }
            
            if error != nil {
                // TODO: do something when error
            }
        }
    }
}

extension PopularViewController: UITableViewDataSource {
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
            cell.actionsDelegate = self
            cell.configRow(
                items: popularMovies,
                itemWidth: MovieViewCell.Size.width.rawValue,
                itemHeight: MovieViewCell.Size.height.rawValue
            )
        
//        case "TV Shows":
//            let items = results[category] as! [PersonPreview]
//            cell.configRow(
//                items: items,
//                itemWidth: PersonViewCell.Size.width.rawValue,
//                itemHeight: PersonViewCell.Size.heightWithoutSub.rawValue
//            )

        default:
            print("Items out of type on category: \(category) - index: \(indexPath.section)")
        }
        return cell
    }
}

extension PopularViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let category = categories[indexPath.section]
        var height: Int {
            switch category {
            case "Movies":
                return MovieViewCell.Size.height.rawValue * 2
                
//            case "People":
//                return PersonViewCell.Size.heightWithoutSub.rawValue
                
            default:
                return 0
            }
        }
        
        return CGFloat(height + minSpacing + collectionRowTopConstraint + collectionRowBottomConstraint)
    }
}

extension PopularViewController: CollectionRowProtocol {
    func onMovieNavigation(movieId: Int) {
        apiManager.getDetailsMovie(movieId: movieId) { (movie, error) in
            if let movie = movie {
                self.segueItem = movie
                self.performSegue(withIdentifier: "fromPopularToMovie", sender: nil)
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
        // Unnecesary in this VC
    }
}
