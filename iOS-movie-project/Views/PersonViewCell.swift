//
//  PersonViewCell.swift
//  iOS-movie-project
//
//  Created by Manu on 23/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit
import Kingfisher

class PersonViewCell: UICollectionViewCell {

    @IBOutlet weak var personProfile: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var category: Category!
    var person: PersonPreview? = nil
    var cast: CastMember? = nil
    var crew: CrewMember? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        personProfile.layer.borderWidth = 2
        personProfile.layer.borderColor = UIColor(named: "Person")?.cgColor
        personProfile.layer.cornerRadius = CGFloat(20)
        
        subtitleLabel.isHidden = false
    }

    func configCell(personPreview: PersonPreview) {
        self.category = Category.personPreview
        self.person = personPreview
        
        if let profilePath = personPreview.profilePath {
            personProfile.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.profileSize.rawValue)\(profilePath)"))
        } else {
            personProfile.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }
        
        personName.text = personPreview.name
        subtitleLabel.isHidden = true
    }
    
    func configCell(castMember: CastMember) {
        self.category = Category.castMember
        self.cast = castMember
        
        if let profilePath = castMember.profilePath {
            personProfile.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.profileSize.rawValue)\(profilePath)"))
        } else {
            personProfile.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }
        
        personName.text = castMember.name
        subtitleLabel.text = castMember.character
    }
    
    func configCell(crewMember: CrewMember) {
        self.category = Category.crewMember
        self.crew = crewMember
        
        if let profilePath = crewMember.profilePath {
            personProfile.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.profileSize.rawValue)\(profilePath)"))
        } else {
            personProfile.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }
        
        personName.text = crewMember.name
        subtitleLabel.text = crewMember.job
    }
}

extension PersonViewCell {
    enum Category {
        case personPreview
        case castMember
        case crewMember
    }
    
    enum Size: Int {
        case width = 96
        case heightWithSub = 136
        case heightWithoutSub = 118
    }
}
