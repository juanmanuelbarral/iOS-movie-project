//
//  TvShowViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 1/7/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class TvShowViewController: UIViewController {

    @IBOutlet weak var backdropDecoration: UIImageView!
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // ABOUT OUTLETS
    @IBOutlet weak var aboutContentView: UIView!
    @IBOutlet weak var startYearLabel: UILabel!
    @IBOutlet weak var finishYearLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var seasonsLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var creditsCollectionView: UICollectionView!
    @IBOutlet weak var similarTvShowsCollectionView: UICollectionView!
    
    // SEASON OUTLETS
    @IBOutlet weak var seasonsContentView: UIView!
    @IBOutlet weak var seasonsCollectionView: UICollectionView!
    
    // PROPERTIES
    private let apiManager = ApiManager.sharedInstance
    private var segueItem: Any? = nil
    private var credits: [Member] = []
//    private var similarShows: [TvShowPreview] = []
//    private var seasons: [Season] = []
//    var tvShow: TvShow!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creditsCollectionView.dataSource = self
        creditsCollectionView.delegate = self
        creditsCollectionView.register(UINib(nibName: "PersonViewCell", bundle: nil), forCellWithReuseIdentifier: "personCell")
        
        similarTvShowsCollectionView.dataSource = self
        similarTvShowsCollectionView.delegate = self
//        similarTvShowsCollectionView.register(UINib(nibName: "TvShowViewCell", bundle: nil), forCellWithReuseIdentifier: "tvShowCell")
        
        seasonsCollectionView.dataSource = self
        seasonsCollectionView.delegate = self
        //        similarTvShowsCollectionView.register(UINib(nibName: "TvShowViewCell", bundle: nil), forCellWithReuseIdentifier: "tvShowCell")
        
        posterImage.layer.borderWidth = 3
        posterImage.layer.borderColor = UIColor(named: "Tv Show")?.cgColor
        
        loadImages()
        loadInfo()
        loadCredits()
        loadSimilarTvShows()
        loadSeasons()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vC = segue.destination {
//            do something
//        }
    }
    
    private func loadImages() {}
    
    private func loadInfo() {}
    
    private func loadCredits() {}
    
    private func loadSimilarTvShows() {}
    
    private func loadSeasons() {}

}

extension TvShowViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension TvShowViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // do the actions
    }
}
