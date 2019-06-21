//
//  Person.swift
//  iOS-movie-project
//
//  Created by Manu on 16/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class Person: Mappable {
    
    var personId: Int!
    var name: String?
    var profilePath: String!
    var birthday: String?
    var deathday: String?
    var department: String?
    var biography: String?
    var placeOfBirth: String?
    var imbdId: String?
    
    required init?(map: Map) {
        if map.JSON[Keys.personId.rawValue] == nil { return nil }
        if map.JSON[Keys.profilePath.rawValue] == nil {
            profilePath = ApiManager.Images.imageNotFound.rawValue
        }
    }

    func mapping(map: Map) {
        personId <- map[Keys.personId.rawValue]
        name <- map[Keys.name.rawValue]
        birthday <- map[Keys.birthday.rawValue]
        deathday <- map[Keys.deathday.rawValue]
        department <- map[Keys.department.rawValue]
        biography <- map[Keys.biography.rawValue]
        placeOfBirth <- map[Keys.placeOfBirth.rawValue]
        profilePath <- map[Keys.profilePath.rawValue]
        imbdId <- map[Keys.imbdId.rawValue]
    }
}

extension Person {
    enum Keys: String {
        case personId = "id"
        case name
        case birthday
        case deathday
        case department = "known_for_department"
        case biography
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case imbdId = "imdb_id"
    }
}
