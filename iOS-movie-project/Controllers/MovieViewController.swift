//
//  MovieViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 24/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

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
    
    var movie: Movie? = nil
    var movieId: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        similarMoviesCollectionView.dataSource = self
        similarMoviesCollectionView.delegate = self

        posterImage.layer.borderWidth = 3
        posterImage.layer.borderColor = UIColor(named: "Movie")?.cgColor
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
