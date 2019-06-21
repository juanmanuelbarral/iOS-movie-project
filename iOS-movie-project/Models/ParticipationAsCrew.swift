//
//  ParticipationAsCrew.swift
//  iOS-movie-project
//
//  Created by Manu on 20/6/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import ObjectMapper

class ParticipationAsCrew: Participation {
    
    var job: String?
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["job"] == nil {
            job = "N/A"
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        job <- map["job"]
    }
}
