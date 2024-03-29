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
    var name: String!
    var profilePath: String?
    var birthday: Date?
    var deathday: Date?
    var department: String?
    var biography: String?
    var placeOfBirth: String?
    var imbdId: String?
    
    required init?(map: Map) {
        if map.JSON[Keys.personId.rawValue] == nil { return nil }
        if map.JSON[Keys.name.rawValue] == nil { return nil }
    }

    func mapping(map: Map) {
        personId <- map[Keys.personId.rawValue]
        name <- map[Keys.name.rawValue]
        birthday <- (map[Keys.birthday.rawValue], CustomReleaseDateTransform())
        deathday <- (map[Keys.deathday.rawValue], CustomReleaseDateTransform())
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
