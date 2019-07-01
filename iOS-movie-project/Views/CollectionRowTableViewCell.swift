//
//  CollectionRowTableViewCell.swift
//  iOS-movie-project
//
//  Created by Manu on 30/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class CollectionRowTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionViewRow: UICollectionView!
    
    var actionsDelegate: CollectionRowProtocol?
    var category: Category!
    var items: [Any] = []
    var width: Int = 0
    var height: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewRow.dataSource = self
        collectionViewRow.delegate = self
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configRow(items: [MoviePreview], itemWidth: Int, itemHeight:Int) {
        self.category = Category.movie
        self.collectionViewRow.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
        configRowGeneral(items: items, itemWidth: itemWidth, itemHeight: itemHeight)
    }
    
    func configRow(items: [PersonPreview], itemWidth: Int, itemHeight:Int) {
        self.category = Category.person
        self.collectionViewRow.register(UINib(nibName: "PersonViewCell", bundle: nil), forCellWithReuseIdentifier: "personCell")
        configRowGeneral(items: items, itemWidth: itemWidth, itemHeight: itemHeight)
    }
    
    private func configRowGeneral(items: [Any], itemWidth: Int, itemHeight:Int) {
        self.items = items
        self.width = itemWidth
        self.height = itemHeight
        self.collectionViewRow.reloadData()
    }
}

extension CollectionRowTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch category! {
        case Category.movie:
            return cellMoviePreview(collectionView, indexPath)
            
        case Category.person:
            return cellPersonPreview(collectionView, indexPath)
        }
    }
    
    private func cellMoviePreview(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> MovieViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieViewCell
        let item = self.items[indexPath.row] as! MoviePreview
        cell.configCell(moviePreview: item)
        return cell
    }
    
    private func cellPersonPreview(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> PersonViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personCell", for: indexPath) as! PersonViewCell
        let item = self.items[indexPath.row] as! PersonPreview
        cell.configCell(personPreview: item)
        return cell
    }
}

extension CollectionRowTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.width, height: self.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = actionsDelegate {
            switch category! {
            case Category.movie:
                let movie = items[indexPath.row] as! MoviePreview
                delegate.onMovieNavigation(movieId: movie.movieId!)
                
            case Category.person:
                let person = items[indexPath.row] as! PersonPreview
                delegate.onPersonNavigation(personId: person.personId!)
            }
        }
    }
}

extension CollectionRowTableViewCell {
    enum Category {
        case movie
        case person
    }
}
