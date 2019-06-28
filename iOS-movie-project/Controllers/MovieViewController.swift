//
//  MovieViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 24/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit
import Kingfisher

class MovieViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var backdropImageHeight: NSLayoutConstraint!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var overviewText: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var runtime: UILabel!
    
    let apiManager = ApiManager.sharedInstance
    var movie: Movie!
    var cast: [CastMember] = []
    var similarMovies: [MoviePreview] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        castCollectionView.register(UINib(nibName: "PersonViewCell", bundle: nil), forCellWithReuseIdentifier: "personCell")
        
        similarMoviesCollectionView.dataSource = self
        similarMoviesCollectionView.delegate = self
        similarMoviesCollectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")

        posterImage.layer.borderWidth = 3
        posterImage.layer.borderColor = UIColor(named: "Movie")?.cgColor
        
        loadImages()
        loadInfo()
        loadCredits()
        loadSimilarMovies()
    }
    
    private func loadImages() {
        if let posterPath = movie.posterPath {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize.rawValue)\(posterPath)"))
        } else {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.imageNotFound.rawValue)"))
        }
        
        if let backdropPath = movie.backdropPath {
            backdropImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.backdropSize.rawValue)\(backdropPath)"))
        } else {
            backdropImageHeight.constant = CGFloat(0)
        }
    }
    
    private func loadInfo() {
        movieTitle.text = movie.title
        overviewText.text = movie.overview ?? "N/A"
        year.text = movie.releaseDate ?? "N/A"
        runtime.text = "\(movie.runtime ?? 0)"
    }
    
    private func loadCredits() {
        apiManager.getMovieCredits(movieId: movie.movieId) { (credits: [Member.Role : [Member]]?, error) in
            if let castMembers = credits?[Member.Role.cast] as? [CastMember] {
                self.cast = castMembers
                self.castCollectionView.reloadData()
            }
            
            if error != nil {
                // TODO: error movie credtis - show something?
            }
        }
    }
    
    private func loadSimilarMovies() {
        apiManager.getSimilarMovies(movieId: movie.movieId) { (moviePreviews, error) in
            if let similarMovies = moviePreviews {
                self.similarMovies = similarMovies
                self.similarMoviesCollectionView.reloadData()
            }
            
            if error != nil {
                // TODO: error similar movies - show something?
            }
        }
    }
}


extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.castCollectionView {
            return cast.count
        } else if collectionView == self.similarMoviesCollectionView {
            return similarMovies.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.castCollectionView {
            return cellForCastCollection(collectionView, indexPath)
        } else if collectionView == self.similarMoviesCollectionView {
            return cellForSimilarMoviesCollection(collectionView, indexPath)
        } else {
            return UICollectionViewCell()
        }
    }
    
    private func cellForCastCollection(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> PersonViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personCell", for: indexPath) as! PersonViewCell
        // Hacer que reciba un cast memeber
//        cell.configCell()
        return cell
    }
    
    private func cellForSimilarMoviesCollection(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> MovieViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieViewCell
        let item = self.similarMovies[indexPath.row]
        cell.configCell(moviePreview: item)
        return cell
    }
}


extension MovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.castCollectionView:
            return CGSize(width: 96, height: 120)
            
        case self.similarMoviesCollectionView:
            return CGSize(width: 104, height: 181)
            
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
