//
//  NotificationsListViewController.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class NotificationsListViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    var presenter: NotificationsListPresenter = NotificationsListPresenter()
    
    /// pull refresh controll
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.Theme.grayUI
        refreshControl.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var bottomLoaderView: BottomLoaderView = {
        let bottomLoader = BottomLoaderView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 50)))
        return bottomLoader
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        presenter.attachView(self)
        presenter.fetchNotifications(usingLoader: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHandler), name: .notificationReceived, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .notificationReceived, object: nil)
        presenter.detachView()
    }
    
    // MARK: - Actions
    
    @objc private func refreshHandler(_ sender: Any) {
        self.refreshControl.endRefreshing()
        presenter.fetchNotifications(usingLoader: false)
    }
    

}

// MARK: - Privates

private extension NotificationsListViewController {

    func setupLayout() {
        self.tableView.delegate = self
        self.tableView.refreshControl = refreshControl
        
        self.navigationItem.title = "NotificationsList.title".localized
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }


}

// MARK: - UITableViewDelegate

extension NotificationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.cellWillDisplayAt(indexPath: indexPath)
    }
    

}

// MARK: - NotificationsListView

extension NotificationsListViewController: NotificationsListView {
    
    func reload(withScrollingToTop: Bool) {
        tableView.reloadData()
        if withScrollingToTop {
            tableView.setContentOffset(.zero, animated: false)
        }
    }
    
    func showBottomLoaderView() {
        tableView.tableFooterView = bottomLoaderView
    }
    
    func hideBottomLoaderView() {
        tableView.tableFooterView = nil
    }
    
    func notificationItemCell(_ cell: NotificationItemTableViewCell, didTappedPhoto atItem: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let galeryViewController = PhotoGalleryViewController(photos: presenter.photosList(at: indexPath), selectedPhotoIndex: atItem)
        let galleryNavigationController = CustomNavigationController(rootViewController: galeryViewController)
        present(galleryNavigationController, animated: true, completion: nil)
    }
    
    func photosList(_ cell: NotificationItemTableViewCell, associatedIndexPath: IndexPath?) -> [String] {
        guard let indexPath = associatedIndexPath else {
            return []
        }
        return presenter.photosList(at: indexPath)
    }
    
    func set(dataSource: TableDataSource<NotificationsListConfigurator>?) {
        dataSource?.connect(to: tableView)
    }
    
    
}



