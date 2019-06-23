//
//  MovieViewCell.swift
//  iOS-movie-project
//
//  Created by Manu on 22/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit
import Kingfisher

class MovieViewCell: UICollectionViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var moviePreview: MoviePreview!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moviePoster.layer.borderWidth = 2
        moviePoster.layer.borderColor = UIColor(hex: 0x00BFFF).cgColor
    }
    
    func configCell(moviePreview: MoviePreview) {
        self.moviePreview = moviePreview
        
        if let posterPath = moviePreview.posterPath {
            moviePoster.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize.rawValue)\(posterPath)"))
        } else {
            moviePoster.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }
        
        movieTitle.text = moviePreview.title
    }
}
