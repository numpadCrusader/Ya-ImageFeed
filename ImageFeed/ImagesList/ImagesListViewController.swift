//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Nikita Khon on 06.02.2025.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: "\(indexPath.row)") else {
            return
        }
        
        cell.photoView.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let likeButtonImageName = (indexPath.row % 2 == 0) ? "like_button_on" : "like_button_off"
        cell.likeButton.setImage(UIImage(named: likeButtonImageName), for: .normal)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
