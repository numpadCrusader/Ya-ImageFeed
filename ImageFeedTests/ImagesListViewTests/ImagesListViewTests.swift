//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Nikita Khon on 17.04.2025.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController?.presenter = presenter
        presenter.view = viewController
        
        _ = viewController?.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsPerformSegue() {
        let presenter = ImagesListPresenter()
        let viewController = ImagesListViewControllerSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.photos = [
            PhotoViewModel(
                id: "123456",
                size: CGSize.zero,
                createdAt: Date(),
                welcomeDescription: "Hello, World",
                thumbImageURL: "google.com",
                largeImageURL: "yandex.ru",
                isLiked: true)
        ]
        
        presenter.didSelectRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(viewController.performSegueCalled)
    }

    func testPhotoViewModelReturnsCorrectData() {
        let presenter = ImagesListPresenter()
        presenter.photos = [
            PhotoViewModel(
                id: "42",
                size: CGSize.zero,
                createdAt: Date(),
                welcomeDescription: "Hello, World",
                thumbImageURL: "google.com",
                largeImageURL: "yandex.ru",
                isLiked: true)
        ]
        
        let result = presenter.photoViewModel(for: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.id, "42")
        XCTAssertEqual(result.isLiked, true)
    }
}
