//
//  CollectionRowProtocol.swift
//  iOS-movie-project
//
//  Created by Manu on 1/7/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

protocol CollectionRowProtocol: class {
    func onMovieNavigation(movieId: Int)
    func onPersonNavigation(personId: Int)
    func onTvShowNavigation(tvShowId: Int)
}
