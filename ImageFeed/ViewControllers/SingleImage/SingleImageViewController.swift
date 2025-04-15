//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Nikita Khon on 13.03.2025.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var singleImageView: UIImageView!
    
    // MARK: - Public Properties
    
    var imageURLString: String? {
        didSet {
            guard isViewLoaded else { return }
            loadImage(urlString: imageURLString)
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        loadImage(urlString: imageURLString)
    }
    
    // MARK: - IBAction
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image = singleImageView.image else { return }
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
    
    private func loadImage(urlString: String?) {
        guard
            let urlString,
            let imageUrl = URL(string: urlString)
        else {
            print("Error: Could not load full screen image. String url is absent/corrupted")
            return
        }
        
        UIBlockingProgressHUD.show()
        singleImageView.kf.setImage(with: imageUrl, completionHandler: { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self = self else { return }
            
                switch result {
                    case .success(let imageResult):
                        self.singleImageView.frame.size = imageResult.image.size
                        self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                        
                    case .failure:
                        print("Error: Could not load full screen image")
                        showError()
                }
            }
        )
    }
    
    private func showError() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так. Попробовать ещё раз?",
            message: nil,
            preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Не надо", style: .default) { _ in }
        alertController.addAction(dismissAction)
        
        let tryAgainAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.loadImage(urlString: self.imageURLString)
        }
        alertController.addAction(tryAgainAction)
        
        present(alertController, animated: true, completion: nil)
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
