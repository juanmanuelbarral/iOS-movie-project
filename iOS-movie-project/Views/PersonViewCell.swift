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
    
    var person: PersonPreview!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        personProfile.layer.borderWidth = 2
        personProfile.layer.borderColor = UIColor(hex: 0x04E762).cgColor
        personProfile.layer.cornerRadius = CGFloat(20)
    }

    func configCell(personPreview: PersonPreview) {
        self.person = personPreview
        
        if let profilePath = personPreview.profilePath {
            personProfile.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl)\(ApiManager.Images.profileSize)\(profilePath)"))
        } else {
            personProfile.kf.setImage(with: URL(string: ApiManager.Images.imageNotFound.rawValue))
        }
        
        personName.text = personPreview.name
    }
}
