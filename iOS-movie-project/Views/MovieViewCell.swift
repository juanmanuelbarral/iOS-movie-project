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
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var category: Category!
    var moviePreview: MoviePreview? = nil
    var cast: ParticipationAsCast? = nil
    var crew: ParticipationAsCrew? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moviePoster.layer.borderWidth = 2
        moviePoster.layer.borderColor = UIColor(named: "Movie")?.cgColor
    }
    
    func configCell(moviePreview: MoviePreview) {
        self.category = Category.moviePreview
        self.moviePreview = moviePreview
        
        if let posterPath = moviePreview.posterPath {
            moviePoster.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize.rawValue)\(posterPath)"))
        } else {
            moviePoster.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }
        
        movieTitle.text = moviePreview.title
        // year
    }
    
    func configCell(participationCast: ParticipationAsCast) {
        self.category = Category.participationAsCast
        self.cast = participationCast
        
        if let posterPath = participationCast.posterPath {
            moviePoster.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize.rawValue)\(posterPath)"))
        } else {
            moviePoster.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }
        
        movieTitle.text = participationCast.title
        subtitleLabel.text = participationCast.character
    }
    
    func configCell(participationCrew: ParticipationAsCrew) {
        self.category = Category.participationAsCrew
        self.crew = participationCrew
        
        if let posterPath = participationCrew.posterPath {
            moviePoster.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize.rawValue)\(posterPath)"))
        } else {
            moviePoster.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }
        
        movieTitle.text = participationCrew.title
        subtitleLabel.text = participationCrew.job
    }
}

extension MovieViewCell {
    enum Category {
        case moviePreview
        case participationAsCast
        case participationAsCrew
    }
    
    enum Size: Int {
        case width = 104
        case height = 195
    }
}
