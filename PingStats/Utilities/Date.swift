//
//  Date.swift
//  PingStats
//
//  Created by Elvis Dorow on 19/11/24.
//

import Foundation

extension Date {
    
    func formattedRelativeDate(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: self)
    }
}
