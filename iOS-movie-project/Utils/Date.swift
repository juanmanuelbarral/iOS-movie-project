//
//  Date.swift
//  iOS-movie-project
//
//  Created by Manu on 1/7/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

extension Date {
    func dateToString(dayFormat: DateFormatter.Style, timeFormat: DateFormatter.Style) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dayFormat
        dateFormatter.timeStyle = timeFormat
        return dateFormatter.string(from: self)
    }
    
    func getYear() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
}
