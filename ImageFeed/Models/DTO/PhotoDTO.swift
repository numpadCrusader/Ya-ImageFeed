//
//  PhotoDTO.swift
//  ImageFeed
//
//  Created by Nikita Khon on 13.04.2025.
//

import Foundation

struct PhotoDTO: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let urls: PhotoUrlsDTO
    let likedByUser: Bool
}

struct PhotoUrlsDTO: Decodable {
    let thumb: String
    let regular: String
}
