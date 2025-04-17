//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Nikita Khon on 17.04.2025.
//

import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var performSegueCalled = false
    
    func configure(_ presenter: ImagesListPresenterProtocol) {}
    
    func performBatchUpdates(for range: Range<Int>) {}
    
    func reloadTableRow(at row: IndexPath) {}
    
    func showLikeChangeError() {}
    
    func performSegue(with sender: Any?) {
        performSegueCalled = true
    }
}
