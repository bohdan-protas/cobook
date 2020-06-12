//
//  AccountViewController.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

private enum Defaults {
    static let estimatedRowHeight: CGFloat = 44
}

class AccountViewController: BaseViewController {

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: Properties
    var presenter = AccountPresenter()
    var dataSource: TableDataSource<AccountDataSourceConfigurator>?

    /// pull refresh controll
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.Theme.grayUI
        refreshControl.addTarget(self, action: #selector(refreshActionHandler(_:)), for: .valueChanged)
        return refreshControl
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileNotificationHandler), name: .profideDataUpdated, object: nil)

        setupLayout()
        presenter.attachView(self)
        presenter.onViewDidLoad()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .profideDataUpdated, object: nil)
        presenter.detachView()
    }

    // MARK: - Actions

    @objc func refreshActionHandler(_ sender: Any) {
        presenter.refresh()
    }

    @objc func updateProfileNotificationHandler(_ notification: Notification) {
        presenter.refresh()
    }

    // MARK: - Privates

    private func setupLayout() {
        //tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Defaults.estimatedRowHeight
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        tableView.refreshControl = refreshControl

        let footerView = UIView(frame: CGRect(origin: .zero, size: .init(width: tableView.frame.width, height: 8)))
        footerView.backgroundColor = .white

        tableView.tableFooterView = footerView
        tableView.delegate = self
    }


}

// MARK: - AccountView

extension AccountViewController: AccountView {

    func reload() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    func set(dataSource: TableDataSource<AccountDataSourceConfigurator>?) {
        dataSource?.connect(to: tableView)
    }


}

// MARK: - UITableViewDelegate

extension AccountViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.selectedRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }


}

// MARK: - AccountHeaderTableViewCellDelegate

extension AccountViewController: AccountHeaderTableViewCellDelegate {

    func userPhotoTapped(cell: AccountHeaderTableViewCell) {
        let galeryViewController = PhotoGalleryViewController(photos: [AppStorage.User.Profile?.avatar?.sourceUrl])
        let galleryNavigationController = CustomNavigationController(rootViewController: galeryViewController)
        present(galleryNavigationController, animated: true, completion: nil)
    }

    func settingTapped(cell: AccountHeaderTableViewCell) {
        let settingsController: SettingsTableViewController = UIStoryboard.account.initiateViewControllerFromType()
        push(controller: settingsController, animated: true)
    }


}

