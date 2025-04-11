//
//  UserDTO.swift
//  ImageFeed
//
//  Created by Nikita Khon on 11.04.2025.
//

import Foundation

struct UserDTO: Decodable {
    let profileImage: ProfileImage
}

struct ProfileImage: Decodable {
    let medium: String
}
