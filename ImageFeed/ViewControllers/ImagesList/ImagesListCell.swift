//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nikita Khon on 09.02.2025.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func didTapChangeLikeButton(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - UITableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoView.kf.cancelDownloadTask()
        dateLabel.text = ""
    }
    
    // MARK: - Public methods
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImageName = isLiked ? "like_button_on" : "like_button_off"
        likeButton.setImage(UIImage(named: likeImageName), for: .normal)
    }
    
    // MARK: - IBAction
    
    @IBAction private func didTapChangeLikeButton(_ sender: UIButton) {
        delegate?.didTapChangeLikeButton(self)
    }
}
