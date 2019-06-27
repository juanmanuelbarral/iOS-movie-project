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
    @IBOutlet weak var overviewText: UITextView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var runtime: UILabel!
    
    var cast: [CastMember] = []
    var similarMovies: [MoviePreview] = []
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        similarMoviesCollectionView.dataSource = self
        similarMoviesCollectionView.delegate = self

        posterImage.layer.borderWidth = 3
        posterImage.layer.borderColor = UIColor(named: "Movie")?.cgColor
        
        loadImages()
        loadInfo()
    }
    
    private func loadImages() {
        if let posterPath = movie.posterPath {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize)/\(posterPath)"))
        } else {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.imageNotFound.rawValue)"))
        }
        
        if let backdropPath = movie.backdropPath {
            backdropImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.backdropSize.rawValue)/\(backdropPath)"))
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
}


extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}


extension MovieViewController: UICollectionViewDelegate {
    
}
