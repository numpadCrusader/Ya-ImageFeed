//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nikita Khon on 09.02.2025.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - UITableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoView.kf.cancelDownloadTask()
        dateLabel.text = ""
    }
}
