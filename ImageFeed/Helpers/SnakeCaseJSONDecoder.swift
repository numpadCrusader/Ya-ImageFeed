//
//  SnakeCaseJSONDecoder.swift
//  ImageFeed
//
//  Created by Nikita Khon on 10.04.2025.
//

import Foundation

final class SnakeCaseJSONDecoder: JSONDecoder {
    
    // MARK: - JSONDecoder
    
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
