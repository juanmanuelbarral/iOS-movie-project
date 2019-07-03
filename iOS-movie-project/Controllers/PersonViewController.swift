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
    @IBOutlet weak var participationTvShowsCollectionView: UICollectionView!
    
    private let apiManager = ApiManager.sharedInstance
    var person: Person!
    private var participationMovies: [Participation] = []
    private var participationTvShows: [Participation] = []
    private var segueItem: Any? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        participationMoviesCollectionView.dataSource = self
        participationMoviesCollectionView.delegate = self
        participationMoviesCollectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "movieParticipationCell")
        
        participationTvShowsCollectionView.dataSource = self
        participationTvShowsCollectionView.delegate = self
        participationTvShowsCollectionView.register(UINib(nibName: "TvShowViewCell", bundle: nil), forCellWithReuseIdentifier: "tvShowParticipationCell")

        profilePicture.layer.borderWidth = 3
        profilePicture.layer.borderColor = UIColor(named: "Person")?.cgColor
        
        loadImages()
        loadInfo()
        loadMoviesParticipation()
        loadTvShowsParticipation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieViewController = segue.destination as? MovieViewController {
            movieViewController.movie = (segueItem as! Movie)
        }
        
        if let tvShowViewController = segue.destination as? TvShowViewController {
            tvShowViewController.tvShow = (segueItem as! TvShow)
        }
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
        bornDateLabel.text = (person.birthday != nil) ? "\(person.birthday!.dateToString(dayFormat: DateFormatter.Style.long, timeFormat: DateFormatter.Style.none)!)" : "-"
        diedDateLabel.text = (person.deathday != nil) ? "\(person.deathday!.dateToString(dayFormat: DateFormatter.Style.long, timeFormat: DateFormatter.Style.none)!)" : "-"
        fromPlaceLabel.text = person.placeOfBirth ?? "-"
        biographyLabel.text = person.biography ?? "N/A"
    }
    
    private func loadMoviesParticipation() {
        apiManager.getMovieCreditsPerson(personId: person.personId) { (response: [Participation.Role : [Participation]]?, error) in
            if let response = response {
                let cast = response[Participation.Role.cast] as! [ParticipationAsCast]
                let crew = response[Participation.Role.crew] as! [ParticipationAsCrew]
                self.participationMovies.append(contentsOf: cast)
                self.participationMovies.append(contentsOf: crew)
                //maybe different sections?
                self.participationMoviesCollectionView.reloadData()
            }
            
            if error != nil {
                // TODO: do something when there is an error
            }
        }
    }
    
    private func loadTvShowsParticipation() {
        apiManager.getTvShowCreditsPerson(personId: person.personId) { (response: [Participation.Role : [Participation]]?, error) in
            if let response = response {
                let cast = response[Participation.Role.cast] as! [ParticipationAsCast]
                let crew = response[Participation.Role.crew] as! [ParticipationAsCrew]
                self.participationTvShows.append(contentsOf: cast)
                self.participationTvShows.append(contentsOf: crew)
                //maybe different sections?
                self.participationTvShowsCollectionView.reloadData()
            }
            
            if error != nil {
                // TODO: do something when there is an error
            }
        }
    }
}


extension PersonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.participationMoviesCollectionView:
            return participationMovies.count
            
        case self.participationTvShowsCollectionView:
            return participationTvShows.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.participationMoviesCollectionView:
            return cellForParticipationMovieCollection(collectionView, indexPath)
            
        case self.participationTvShowsCollectionView:
            return cellForParticipationTvShowCollection(collectionView, indexPath)
            
        default:
            return UICollectionViewCell()
        }
    }
    
    private func cellForParticipationMovieCollection(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> MovieViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieParticipationCell", for: indexPath) as! MovieViewCell
        let item = participationMovies[indexPath.row]

        if let participationCast = item as? ParticipationAsCast {
            cell.configCell(participationCast: participationCast)
        } else if let participationCrew = item as? ParticipationAsCrew {
            cell.configCell(participationCrew: participationCrew)
        }
        return cell
    }
    
    private func cellForParticipationTvShowCollection(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> TvShowViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvShowParticipationCell", for: indexPath) as! TvShowViewCell
        let item = participationTvShows[indexPath.row]
        
        if let participationCast = item as? ParticipationAsCast {
            cell.configCell(participationCast: participationCast)
        } else if let participationCrew = item as? ParticipationAsCrew {
            cell.configCell(participationCrew: participationCrew)
        }
        return cell
    }
}


extension PersonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: Int
        var height: Int
        switch collectionView {
        case self.participationMoviesCollectionView:
            width = MovieViewCell.Size.width.rawValue
            height = MovieViewCell.Size.height.rawValue
            
        case self.participationTvShowsCollectionView:
            width = TvShowViewCell.Size.width.rawValue
            height = TvShowViewCell.Size.heightWithSub.rawValue
            
        default:
            width = 0
            height = 0
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.participationMoviesCollectionView:
            let idMovie = participationMovies[indexPath.row].mediaId!
            apiManager.getDetailsMovie(movieId: idMovie) { (movie, error) in
                if let movie = movie {
                    self.segueItem = movie
                    self.performSegue(withIdentifier: "fromPersonToMovie", sender: nil)
                }
                
                if let error = error {
                    let alert = self.messageAlert(
                        title: "There was a problem with opening this movie",
                        message: "Check your connection to the internet and try again.\n\(error.localizedDescription)"
                    )
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        case self.participationTvShowsCollectionView:
            let idTvShow = participationTvShows[indexPath.row].mediaId!
            apiManager.getDetailsTvShow(tvShowId: idTvShow) { (tvShow, error) in
                if let tvShowSegue = tvShow {
                    self.segueItem = tvShowSegue
                    self.performSegue(withIdentifier: "fromPersonToTv", sender: nil)
                }
                
                if let error = error {
                    let alert = self.messageAlert(
                        title: "There was a problem with opening this Tv Show",
                        message: "Check your connection to the internet and try again.\n\(error.localizedDescription)"
                    )
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        default:
            print("Unreachable case - navigation PersonViewController")
        }
    }
}
