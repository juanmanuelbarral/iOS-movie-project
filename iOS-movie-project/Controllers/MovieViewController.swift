//
//  MovieViewController.swift
//  iOS-movie-project
//
//  Created by Manu on 24/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit
import Kingfisher

class MovieViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var backdropDecorationImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var overviewText: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var runtime: UILabel!
    
    private let apiManager = ApiManager.sharedInstance
    var movie: Movie!
    private var cast: [CastMember] = []
    private var similarMovies: [MoviePreview] = []
    private var segueItem: Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        castCollectionView.register(UINib(nibName: "PersonViewCell", bundle: nil), forCellWithReuseIdentifier: "personCell")
        
        similarMoviesCollectionView.dataSource = self
        similarMoviesCollectionView.delegate = self
        similarMoviesCollectionView.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")

        posterImage.layer.borderWidth = 3
        posterImage.layer.borderColor = UIColor(named: "Movie")?.cgColor
        
        loadImages()
        loadInfo()
        loadCredits()
        loadSimilarMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let personViewController = segue.destination as? PersonViewController {
            personViewController.person = (segueItem as! Person)
        }
    }
    
    private func loadImages() {
        backdropImage.isHidden = false
        backdropDecorationImage.isHidden = true
        
        if let posterPath = movie.posterPath {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.posterSize.rawValue)\(posterPath)"))
        } else {
            posterImage.kf.setImage(with: URL(string: "\(ApiManager.Images.imageNotFound.rawValue)"))
        }
        
        if let backdropPath = movie.backdropPath {
            backdropImage.kf.setImage(with: URL(string: "\(ApiManager.Images.baseUrl.rawValue)\(ApiManager.Images.backdropSize.rawValue)\(backdropPath)"))
        } else {
            backdropImage.isHidden = true
            backdropDecorationImage.isHidden = false
        }
    }
    
    private func loadInfo() {
        movieTitle.text = movie.title
        overviewText.text = movie.overview ?? "N/A"
        year.text = (movie.releaseDate != nil) ? "\(movie.releaseDate!.getYear())" : "N/A"
        if let runtime = movie.runtime {
            let hours: Int = runtime / 60
            let minutes: Int = runtime % 60
            self.runtime.text = "\(hours)h \(minutes)'"
        } else {
            self.runtime.text = "N/A"
        }
    }
    
    private func loadCredits() {
        apiManager.getMovieCredits(movieId: movie.movieId) { (credits: [Member.Role : [Member]]?, error) in
            if let castMembers = credits?[Member.Role.cast] as? [CastMember] {
                self.cast = castMembers
                self.castCollectionView.reloadData()
            }
            
            if error != nil {
                // TODO: error movie credtis - show something?
            }
        }
    }
    
    private func loadSimilarMovies() {
        apiManager.getSimilarMovies(movieId: movie.movieId) { (moviePreviews, error) in
            if let similarMovies = moviePreviews {
                self.similarMovies = similarMovies
                self.similarMoviesCollectionView.reloadData()
            }
            
            if error != nil {
                // TODO: error similar movies - show something?
            }
        }
    }
}


extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.castCollectionView:
            return cast.count
            
        case self.similarMoviesCollectionView:
            return similarMovies.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.castCollectionView:
            return cellForCastCollection(collectionView, indexPath)
            
        case self.similarMoviesCollectionView:
            return cellForSimilarMoviesCollection(collectionView, indexPath)
            
        default:
            return UICollectionViewCell()
        }
    }
    
    private func cellForCastCollection(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> PersonViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personCell", for: indexPath) as! PersonViewCell
        let item = cast[indexPath.row]
        cell.configCell(castMember: item)
        return cell
    }
    
    private func cellForSimilarMoviesCollection(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> MovieViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieViewCell
        let item = self.similarMovies[indexPath.row]
        cell.configCell(moviePreview: item)
        return cell
    }
}


extension MovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: Int
        var height: Int
        switch collectionView {
        case self.castCollectionView:
            width = PersonViewCell.Size.width.rawValue
            height = PersonViewCell.Size.heightWithSub.rawValue
            
        case self.similarMoviesCollectionView:
            width = MovieViewCell.Size.width.rawValue
            height = MovieViewCell.Size.height.rawValue
            
        default:
            width = 0
            height = 0
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.castCollectionView:
            let idPerson = cast[indexPath.row].personId!
            apiManager.getDetailsPerson(personId: idPerson) { (person, error) in
                if let person = person {
                    self.segueItem = person
                    self.performSegue(withIdentifier: "fromMovieToPerson", sender: nil)
                }
                
                if let error = error {
                    let alert = self.messageAlert(
                        title: "There was a problem with opening this person's information",
                        message: "Check your connection to the internet and try again.\n\(error.localizedDescription)"
                    )
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        case self.similarMoviesCollectionView:
            let idMovie = similarMovies[indexPath.row].movieId!
            apiManager.getDetailsMovie(movieId: idMovie) { (movie, error) in
                if let movie = movie {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let movieViewController = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
                    movieViewController.movie = movie
                    self.navigationController!.pushViewController(movieViewController, animated: false)
                }
                
                if let error = error {
                    let alert = self.messageAlert(
                        title: "There was a problem with opening this movie",
                        message: "Check your connection to the internet and try again.\n\(error.localizedDescription)"
                    )
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        default:
            print("Unreachable case - navigation MovieViewController")
        }
    }
}
