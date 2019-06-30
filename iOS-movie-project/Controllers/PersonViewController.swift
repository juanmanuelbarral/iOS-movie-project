//
//  PersonViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 25/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit
import Kingfisher

class PersonViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var knownForLabel: UILabel!
    @IBOutlet weak var bornDateLabel: UILabel!
    @IBOutlet weak var diedDateLabel: UILabel!
    @IBOutlet weak var fromPlaceLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var participationMoviesCollectionView: UICollectionView!
    
    var person: Person!
    var participationMovies: [Participation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        participationMoviesCollectionView.dataSource = self
        participationMoviesCollectionView.delegate = self
        participationMoviesCollectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "movieParticipationCell")

        profilePicture.layer.borderWidth = 3
        profilePicture.layer.borderColor = UIColor(named: "Person")?.cgColor
        
        loadImages()
        loadInfo()
    }
    
    private func loadImages() {
        if let profilePath = person.profilePath {
            profilePicture.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.profileSize.rawValue)\(profilePath)"))
        } else {
            profilePicture.kf.setImage(with: URL(string: "\(ApiManager.Images.imageNotFound.rawValue)"))
        }
    }
    
    private func loadInfo() {
        nameLabel.text = person.name
        knownForLabel.text = person.department ?? ""
        bornDateLabel.text = person.birthday ?? "-"
        diedDateLabel.text = person.deathday ?? "-"
        fromPlaceLabel.text = person.placeOfBirth ?? "-"
        biographyLabel.text = person.biography ?? "N/A"
    }
    
    private func loadMoviesParticipation() {
        
    }
}


extension PersonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.participationMoviesCollectionView:
            return participationMovies.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.participationMoviesCollectionView:
            return cellForParticipationMovieCollection(collectionView, indexPath)
            
        default:
            return UICollectionViewCell()
        }
    }
    
    private func cellForParticipationMovieCollection(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> MovieViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieParticipationCell", for: indexPath) as! MovieViewCell
        let item = participationMovies[indexPath.row]
//        cell.configCell(moviePreview: T##MoviePreview)
        return cell
    }
}


extension PersonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.participationMoviesCollectionView:
            return CGSize(width: 104, height: 181)
            
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
