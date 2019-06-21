//
//  ParticipationAsCast.swift
//  iOS-movie-project
//
//  Created by Manu on 16/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class ParticipationAsCast: Participation {
    
    var character: String?
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["character"] == nil {
            character = "N/A"
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        character <- map["character"]
    }    
}
