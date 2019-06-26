//
//  PersonViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 25/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var knownForLabel: UILabel!
    @IBOutlet weak var bornDateLabel: UILabel!
    @IBOutlet weak var diedDateLabel: UILabel!
    @IBOutlet weak var fromPlaceLabel: UILabel!
    @IBOutlet weak var biographyText: UITextView!
    @IBOutlet weak var participationCollectionView: UICollectionView!
    
    var person: Person? = nil
    var personId: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        participationCollectionView.dataSource = self
        participationCollectionView.delegate = self

        profilePicture.layer.borderWidth = 3
        profilePicture.layer.borderColor = UIColor(named: "Person")?.cgColor
    }
}


extension PersonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}


extension PersonViewController: UICollectionViewDelegate {
    
}
