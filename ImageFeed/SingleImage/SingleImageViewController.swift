//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Nikita Khon on 13.03.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var singleImageView: UIImageView!
    
    // MARK: - Public Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            singleImageView.image = image
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.image = image
    }
}
