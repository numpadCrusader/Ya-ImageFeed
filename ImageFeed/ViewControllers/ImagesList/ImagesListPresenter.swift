//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Nikita Khon on 17.04.2025.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [PhotoViewModel] { get }
    
    func viewDidLoad()
    func handleLikeTap(at indexPath: IndexPath, for cell: ImagesListCell)
    func fetchPhotosNextPageIfNeeded()
    func didSelectRow(at indexPath: IndexPath)
    func photoViewModel(for indexPath: IndexPath) -> PhotoViewModel
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    // MARK: - Public Properties
    
    weak var view: ImagesListViewControllerProtocol?
    var photos: [PhotoViewModel] = []
    
    // MARK: - Private Properties
    
    private let oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - ImagesListPresenterProtocol
    
    func viewDidLoad() {
        addObserver()
    }
    
    func handleLikeTap(at indexPath: IndexPath, for cell: ImagesListCell) {
        guard let token = oAuth2TokenStorage.token else {
            return
        }
        
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(token: token, photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                    self.view?.reloadTableRow(at: indexPath)
                    
                case .failure:
                    print("Error: Could not change like for chosen photo")
                    self.view?.showLikeChangeError()
                    
            }
        }
    }
    
    func fetchPhotosNextPageIfNeeded() {
        guard let token = oAuth2TokenStorage.token else {
            return
        }
        
        imagesListService.fetchPhotosNextPage(token: token) { _ in }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        view?.performSegue(with: photos[indexPath.row].largeImageURL)
    }
    
    func photoViewModel(for indexPath: IndexPath) -> PhotoViewModel {
        photos[indexPath.row]
    }
    
    // MARK: - Private Methods
    
    private func addObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        guard oldCount != newCount else { return }
        
        photos = imagesListService.photos
        view?.performBatchUpdates(for: oldCount..<newCount)
    }
}
