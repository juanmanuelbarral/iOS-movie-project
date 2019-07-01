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
    
    let headerHeight: Int = 30
    let firstHeaderExtra: Int = 40
    let minSpacing: Int = 10
    let collectionRowTopConstraint: Int = 10
    let collectionRowBottomConstraint: Int = 35
    
    let apiManager = ApiManager.sharedInstance
    let categories = ["Movies"]
    var popularMovies: [MoviePreview] = []
    var segueElement: Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popularTableView.dataSource = self
        popularTableView.delegate = self
        popularTableView.register(UINib(nibName: "CollectionRowTableViewCell", bundle: nil), forCellReuseIdentifier: "collectionRow")
        
        loadPopularMovies()
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
