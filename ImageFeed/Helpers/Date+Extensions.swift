//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Nikita Khon on 14.04.2025.
//

import Foundation

extension Date {
    var russianDateString: String { DateFormatter.defaultDateTime.string(from: self) }
}

private extension DateFormatter {
    
    static let defaultDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
