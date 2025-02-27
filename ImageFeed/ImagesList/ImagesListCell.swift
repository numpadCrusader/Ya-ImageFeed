//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nikita Khon on 09.02.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
}
