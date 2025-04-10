//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Nikita Khon on 10.04.2025.
//

import Foundation

struct ProfileDTO: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}
