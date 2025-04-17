//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Nikita Khon on 17.04.2025.
//

import Foundation
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled = false
    var view: ImagesListViewControllerProtocol?
    var photos: [PhotoViewModel] = []
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func handleLikeTap(at indexPath: IndexPath, for cell: ImagesListCell) {}
    
    func fetchPhotosNextPageIfNeeded() {}
    
    func didSelectRow(at indexPath: IndexPath) {}
    
    func photoViewModel(for indexPath: IndexPath) -> PhotoViewModel {
        PhotoViewModel(
            id: "123456",
            size: CGSize.zero,
            createdAt: Date(),
            welcomeDescription: "Hello, World",
            thumbImageURL: "google.com",
            largeImageURL: "yandex.ru",
            isLiked: true)
    }
}
