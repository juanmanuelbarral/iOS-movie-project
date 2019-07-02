//
//  CustomReleaseDateTransform.swift
//  iOS-movie-project
//
//  Created by Manu on 1/7/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import ObjectMapper

class CustomReleaseDateTransform: TransformType {
    typealias Object = Date
    typealias JSON = String
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let dateString = value as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone.current
            return formatter.date(from: dateString)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = value {
            return formatter.string(from: date)
        }
        return nil
    }
}
