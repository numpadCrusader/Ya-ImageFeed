//
//  PhotoDTO.swift
//  ImageFeed
//
//  Created by Nikita Khon on 13.04.2025.
//

import Foundation

struct PhotoDTOWrapper: Decodable {
    let photo: PhotoDTO
}

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
    let regular: String
    let full: String
}
