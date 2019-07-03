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
    private var similarShows: [TvShowPreview] = []
    var tvShow: TvShow!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creditsCollectionView.dataSource = self
        creditsCollectionView.delegate = self
        creditsCollectionView.register(UINib(nibName: "PersonViewCell", bundle: nil), forCellWithReuseIdentifier: "personCell")
        
        similarTvShowsCollectionView.dataSource = self
        similarTvShowsCollectionView.delegate = self
        similarTvShowsCollectionView.register(UINib(nibName: "TvShowViewCell", bundle: nil), forCellWithReuseIdentifier: "tvShowCell")
        
        seasonsCollectionView.dataSource = self
        seasonsCollectionView.delegate = self
        similarTvShowsCollectionView.register(UINib(nibName: "TvShowViewCell", bundle: nil), forCellWithReuseIdentifier: "seasonCell")
        
        posterImage.layer.borderWidth = 3
        posterImage.layer.borderColor = UIColor(named: "Tv Show")?.cgColor
        
        loadImages()
        loadInfo()
        loadCredits()
        loadSimilarTvShows()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let personViewController = segue.destination as? PersonViewController {
            personViewController.person = (segueItem as! Person)
        }
    }
    
    private func loadImages() {
        backdropImage.isHidden = false
        backdropDecoration.isHidden = true
        
        if let posterPath = tvShow.posterPath {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize.rawValue)\(posterPath)"))
        } else {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.imageNotFound.rawValue)"))
        }
        
        if let backdropPath = tvShow.backdropPath {
            backdropImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.backdropSize.rawValue)\(backdropPath)"))
        } else {
            backdropImage.isHidden = true
            backdropDecoration.isHidden = false
        }
    }
    
    private func loadInfo() {
        titleLabel.text = tvShow.name
        startYearLabel.text = (tvShow.firstAirDate != nil) ? "\(tvShow.firstAirDate!.getYear())" : "N/A"
        finishYearLabel.text = (tvShow.lastAirDate != nil) ? "\(tvShow.lastAirDate!.getYear())" : "N/A"
        statusLabel.text = tvShow.status ?? "-"
        seasonsLabel.text = (tvShow.numberOfSeasons != nil) ? "\(tvShow.numberOfSeasons!)" : "N/A"
        episodesLabel.text = (tvShow.numberOfEpisodes != nil) ? "\(tvShow.numberOfEpisodes!)" : "N/A"
        if let runtime = tvShow.runtime?[0] {
            let hours: Int = runtime / 60
            let minutes: Int = runtime % 60
            runtimeLabel.text = (hours > 0) ? "\(hours)h \(minutes)'" : "\(minutes)'"
        } else {
            runtimeLabel.text = "N/A"
        }
        overviewLabel.text = tvShow.overview ?? "N/A"
    }
    
    private func loadCredits() {
        apiManager.getTvShowCredits(tvShowId: tvShow.tvShowId) { (credits: [Member.Role : [Member]]?, error) in
            if let castMembers = credits?[Member.Role.cast] as? [CastMember] {
                self.credits = castMembers
                self.creditsCollectionView.reloadData()
            }
            
            if error != nil {
                // TODO: error movie credtis - show something?
            }
        }
    }
    
    private func loadSimilarTvShows() {
        apiManager.getSimilarTvShows(tvShowId: tvShow.tvShowId) { (tvShowPreviews, error) in
            if let similarTvShows = tvShowPreviews {
                self.similarShows = similarTvShows
                self.similarTvShowsCollectionView.reloadData()
            }
            
            if error != nil {
                // TODO: error similar movies - show something?
            }
        }
    }
}

extension TvShowViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.creditsCollectionView:
            return credits.count
            
        case self.similarTvShowsCollectionView:
            return similarShows.count
            
        case self.seasonsCollectionView:
            return tvShow.seasons?.count ?? 0
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.creditsCollectionView:
            return cellForCreditsCollection(collectionView, indexPath)
            
        case self.similarTvShowsCollectionView:
            return cellForSimilarTvShowsCollection(collectionView, indexPath)
            
        case self.seasonsCollectionView:
            return cellForSeasonsCollection(collectionView, indexPath)
            
        default:
            return UICollectionViewCell()
        }
    }
    
    private func cellForCreditsCollection(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> PersonViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personCell", for: indexPath) as! PersonViewCell
        let item = credits[indexPath.row]
        if let cast = item as? CastMember {
            cell.configCell(castMember: cast)
        }
        else if let crew = item as? CrewMember {
            cell.configCell(crewMember: crew)
        }
        return cell
    }
    
    private func cellForSimilarTvShowsCollection(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> TvShowViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvShowCell", for: indexPath) as! TvShowViewCell
        let item = self.similarShows[indexPath.row]
        cell.configCell(tvShowPreview: item)
        return cell
    }
    
    private func cellForSeasonsCollection(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> TvShowViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seasonCell", for: indexPath) as! TvShowViewCell
        let item = self.tvShow.seasons![indexPath.row]
        cell.configCell(season: item)
        return cell
    }
}

extension TvShowViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: Int
        var height: Int
        switch collectionView {
        case self.creditsCollectionView:
            width = PersonViewCell.Size.width.rawValue
            height = PersonViewCell.Size.heightWithSub.rawValue
            
        case self.similarTvShowsCollectionView:
            width = TvShowViewCell.Size.width.rawValue
            height = TvShowViewCell.Size.heightWithoutSub.rawValue
        
        case self.seasonsCollectionView:
            width = TvShowViewCell.Size.width.rawValue
            height = TvShowViewCell.Size.heightWithoutSub.rawValue
            
        default:
            width = 0
            height = 0
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.creditsCollectionView:
            let idPerson = credits[indexPath.row].personId!
            apiManager.getDetailsPerson(personId: idPerson) { (person, error) in
                if let person = person {
                    self.segueItem = person
                    self.performSegue(withIdentifier: "fromTvToPerson", sender: nil)
                }
                
                if let error = error {
                    let alert = self.messageAlert(
                        title: "There was a problem with opening this person's information",
                        message: "Check your connection to the internet and try again.\n\(error.localizedDescription)"
                    )
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        case self.similarTvShowsCollectionView:
            let idTvShow = similarShows[indexPath.row].tvShowId!
            apiManager.getDetailsTvShow(tvShowId: idTvShow) { (tvShow, error) in
                if let tvShowSegue = tvShow {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tvShowViewController = storyboard.instantiateViewController(withIdentifier: "TvShowViewController") as! TvShowViewController
                    tvShowViewController.tvShow = tvShowSegue
                    self.navigationController!.pushViewController(tvShowViewController, animated: false)
                }
                
                if let error = error {
                    let alert = self.messageAlert(
                        title: "There was a problem with opening this Tv Show",
                        message: "Check your connection to the internet and try again.\n\(error.localizedDescription)"
                    )
                    self.present(alert, animated: true, completion: nil)
                }
            }
        
        case self.seasonsCollectionView:
//            let idTvShow = tvShow.tvShowId
//            let seasonNumber = tvShow.seasons![indexPath.row].seasonNumber
            print("No navigation to seasons yet")
            
        default:
            print("Unreachable case - navigation TvViewController")
        }
    }
}
