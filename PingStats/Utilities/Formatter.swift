//
//  Formatter.swift
//  PingStats
//
//  Created by Elvis Dorow on 16/09/24.
//

import Foundation

class Formatter {
    
    static func number(_ number: Double, fraction: Int, unit: String, separator: String = ".") -> String {
        if number >= 0 {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = fraction
            formatter.maximumFractionDigits = fraction
            formatter.decimalSeparator = separator
            let formattedNumber = formatter.string(from: NSNumber(value: number))
            
            if let strNumber = formattedNumber {
                return "\(strNumber) \(unit)"
            }
        }
        return "--"
    }
    
    static func elapsedTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension Double {
    func pingDurationFormat() -> String {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        if self < 1.0 {
            formatter.minimumFractionDigits = 3
            formatter.maximumFractionDigits = 3
        } else {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        }
        return formatter.string(from: NSNumber(value: self)) ?? String(self)
    }
}

extension Date {
    func formattedRelativeDate(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: self)
    }
}
