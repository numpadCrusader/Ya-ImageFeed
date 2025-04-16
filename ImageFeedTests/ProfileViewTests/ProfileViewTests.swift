//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Nikita Khon on 16.04.2025.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view

        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdates() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.didUpdateLabels)
        XCTAssertFalse(viewController.didUpdateAvatar)
    }
    
    func testPresenterShowsLogoutAlert() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController

        presenter.didTapLogout()

        XCTAssertTrue(viewController.didShowAlert)
    }
}
