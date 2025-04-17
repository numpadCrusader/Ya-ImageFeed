//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Nikita Khon on 06.02.2025.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get }
    func configure(_ presenter: ImagesListPresenterProtocol)
    func performBatchUpdates(for range: Range<Int>)
    func reloadTableRow(at row: IndexPath)
    func showLikeChangeError()
    func performSegue(with sender: Any?)
}

final class ImagesListViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Public Properties
    
    var presenter: ImagesListPresenterProtocol?
    
    // MARK: - Private Properties
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let imageUrlString = sender as? String
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            viewController.imageURLString = imageUrlString
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath) as? ImagesListCell,
            let viewModel = presenter?.photoViewModel(for: indexPath)
        else {
            return UITableViewCell()
        }
        
        imageListCell.configure(with: viewModel)
        imageListCell.delegate = self
        
        return imageListCell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = presenter?.photos[indexPath.row].size ?? CGSize.zero
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard !ProcessInfo.processInfo.arguments.contains("UITest") else { return }
        
        guard indexPath.row + 1 == presenter?.photos.count else {
            return
        }
        
        presenter?.fetchPhotosNextPageIfNeeded()
    }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    
    func didTapChangeLikeButton(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        presenter?.handleLikeTap(at: indexPath, for: cell)
    }
    
    func didFinishConfiguring(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - ImagesListViewControllerProtocol

extension ImagesListViewController: ImagesListViewControllerProtocol {
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func performBatchUpdates(for range: Range<Int>) {
        tableView.performBatchUpdates {
            let indexPaths = range.map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func reloadTableRow(at row: IndexPath) {
        tableView.reloadRows(at: [row], with: .none)
    }
    
    func showLikeChangeError() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так. Не удалось изменить лайк",
            message: nil,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func performSegue(with sender: Any?) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: sender)
    }
}
