//
//  String+Extensions.swift
//  ImageFeed
//
//  Created by Nikita Khon on 14.04.2025.
//

import Foundation

extension String {
    var date: Date? { ISO8601DateFormatter.isoFormatter.date(from: self) }
}

private extension ISO8601DateFormatter {
    
    static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
}
