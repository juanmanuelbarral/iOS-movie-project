//
//  TvShowViewCell.swift
//  iOS-movie-project
//
//  Created by Manu on 2/7/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class TvShowViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var category: Category!
    var tvShowPreview: TvShowPreview? = nil
    var cast: ParticipationAsCast? = nil
    var crew: ParticipationAsCrew? = nil
    var season: SeasonPreview? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImage.layer.borderWidth = 2
        posterImage.layer.borderColor = UIColor(named: "Tv Show")?.cgColor
    }
    
    func configCell(tvShowPreview: TvShowPreview) {
        self.category = Category.tvShowPreview
        self.tvShowPreview = tvShowPreview

        if let posterPath = tvShowPreview.posterPath {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize.rawValue)\(posterPath)"))
        } else {
            posterImage.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }

        titleLabel.text = tvShowPreview.name
        subtitleLabel.isHidden = true
    }
    
    func configCell(participationCast: ParticipationAsCast) {
        self.category = Category.participationAsCast
        self.cast = participationCast
        
        if let posterPath = participationCast.posterPath {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize.rawValue)\(posterPath)"))
        } else {
            posterImage.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }
        
        titleLabel.text = participationCast.title
        subtitleLabel.text = participationCast.character
    }
    
    func configCell(participationCrew: ParticipationAsCrew) {
        self.category = Category.participationAsCrew
        self.crew = participationCrew
        
        if let posterPath = participationCrew.posterPath {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize.rawValue)\(posterPath)"))
        } else {
            posterImage.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }
        
        titleLabel.text = participationCrew.title
        subtitleLabel.text = participationCrew.job
    }
    
    func configCell(season: SeasonPreview) {
        self.category = Category.season
        self.season = season
        
        if let posterPath = season.posterPath {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize.rawValue)\(posterPath)"))
        } else {
            posterImage.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }
        
        titleLabel.text = season.name
        subtitleLabel.isHidden = true
    }
}

extension TvShowViewCell {
    enum Category {
        case tvShowPreview
        case participationAsCast
        case participationAsCrew
        case season
    }
    
    enum Size: Int {
        case width = 104
        case heightWithSub = 195
        case heightWithoutSub = 178
    }
}
