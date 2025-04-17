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
    func didFinishConfiguring(_ cell: ImagesListCell)
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
    
    func configure(with viewModel: PhotoViewModel) {
        let avatarURLString = viewModel.thumbImageURL
        
        guard let url = URL(string: avatarURLString) else {
            print("URL Error: Could not create url from string")
            return
        }
        
        photoView.kf.indicatorType = .activity
        photoView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "unloaded_image_card"),
            completionHandler: { [weak self] _ in
                guard let self = self else { return }
                delegate?.didFinishConfiguring(self)
            }
        )
        
        dateLabel.text = viewModel.createdAt?.russianDateString ?? ""
        
        let isLiked = viewModel.isLiked
        setIsLiked(isLiked)
    }
    
    // MARK: - IBAction
    
    @IBAction private func didTapChangeLikeButton(_ sender: UIButton) {
        delegate?.didTapChangeLikeButton(self)
    }
}
