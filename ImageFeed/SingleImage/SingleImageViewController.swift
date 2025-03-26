//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Nikita Khon on 13.03.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var singleImageView: UIImageView!
    
    // MARK: - Public Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            singleImageView.image = image
            singleImageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard let image else { return }
        singleImageView.image = image
        singleImageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK: - IBAction
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        rescaleImageInScrollView(image: image)
        centerImageInScrollView()
    }
    
    private func rescaleImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
    }
    
    private func centerImageInScrollView() {
        let visibleRectSize = scrollView.bounds.size
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize
        let scrollViewSize = scrollView.bounds.size
        
        let horizontalInset = max((scrollViewSize.width - contentSize.width) / 2, 0)
        scrollView.contentInset.left = horizontalInset
        scrollView.contentInset.right = horizontalInset

        let verticalInset = max((scrollViewSize.height - contentSize.height) / 2, 0)
        scrollView.contentInset.top = verticalInset
        scrollView.contentInset.bottom = verticalInset
    }
}
