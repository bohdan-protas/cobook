//
//  SavedContentViewController.swift
//  CoBook
//
//  Created by protas on 5/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import MapKit

class SavedContentViewController: BaseViewController {

    /// main tableView
    @IBOutlet var tableView: UITableView!

    /// itemsBarView
    lazy var itemsBarView: HorizontalItemsBarView = {
        let view = HorizontalItemsBarView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 58)), dataSource: [])
        view.delegate = self
        return view
    }()

    /// pull refresh controll
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.Theme.grayUI
        refreshControl.addTarget(self, action: #selector(refreshAllCardsData(_:)), for: .valueChanged)
        return refreshControl
    }()

    var presenter: SavedContentPresenter = SavedContentPresenter()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveCardSaveOperationHandler), name: .cardSaved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveCardUnsaveOperationHandler), name: .cardUnsaved, object: nil)

        setupLayout()
        presenter.attachView(self)
        presenter.setup(useLoader: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .cardSaved, object: nil)
        NotificationCenter.default.removeObserver(self, name: .cardUnsaved, object: nil)
        presenter.detachView()
    }

    // MARK: - Actions

    @objc private func refreshAllCardsData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        presenter.setup(useLoader: true)
    }

    @objc func onDidReceiveCardSaveOperationHandler(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Any], let controllerID = data[Notification.Key.controllerID] as? String {
            if SavedContentViewController.describing != controllerID {
                presenter.setup(useLoader: false)
            }
        }
    }

    @objc func onDidReceiveCardUnsaveOperationHandler(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Any], let cardID = data[Notification.Key.cardID] as? Int, let controllerID = data[Notification.Key.controllerID] as? String {
            if SavedContentViewController.describing != controllerID {
                self.presenter.unsaveCardItemWith(id: cardID)
                self.reload()
            }
        }
    }

    // MARK: - Public

    func openSettings() {
        let alertController = UIAlertController (title: nil, message: "Перейти в налаштування?", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Налаштування", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }

        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Відмінити", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }


}

// MARK: - Privates

private extension SavedContentViewController {

    func setupLayout() {
        self.tableView.delegate = self
        self.tableView.refreshControl = refreshControl
        self.navigationItem.title = "Saved".localized
        self.navigationItem.largeTitleDisplayMode = .always
    }


}

// MARK: - SavedContentView

extension SavedContentViewController: SavedContentView {

    func goToArticleDetails(presenter: ArticleDetailsPresenter) {
        let controller: ArticleDetailsViewController = UIStoryboard.post.initiateViewControllerFromType()
        controller.presenter = presenter
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func goToBusinessCardDetails(presenter: BusinessCardDetailsPresenter?) {
        let businessCardDetailsViewController: BusinessCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
        businessCardDetailsViewController.presenter = presenter
        self.navigationController?.pushViewController(businessCardDetailsViewController, animated: true)
    }

    func goToPersonalCardDetails(presenter: PersonalCardDetailsPresenter?) {
        let personalCardDetailsViewController: PersonalCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
        personalCardDetailsViewController.presenter = presenter
        self.navigationController?.pushViewController(personalCardDetailsViewController, animated: true)
    }

    func onSaveCard(cell: ContactableCardItemTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            presenter.unsaveCardAt(indexPath: indexPath, successCompletion: { [unowned self] in
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .right)
                self.tableView.endUpdates()
            })
        }
    }

    func onMakeCall(cell: ContactableCardItemTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell), let telephone = presenter.telephoneNumberForItemAt(indexPath: indexPath) {
            self.makeCall(to: telephone)
        }
    }

    func onSendMail(cell: ContactableCardItemTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell), let email = presenter.emailAddressForItemAt(indexPath: indexPath) {
            self.sendEmail(to: email)
        }
    }

    func createFolder() {
        newFolderAlert(folderName: nil, completion: { [unowned self] (folderName) in
            self.presenter.createFolder(title: folderName) { (barItem) in
                self.itemsBarView.append(barItem: barItem)
            }
        })
    }

    func reload() {
        self.tableView.reloadData()
    }

    func set(dataSource: DataSource<SavedContentCellConfigurator>?) {
        dataSource?.connect(to: self.tableView)
    }

    func set(barItems: [BarItem]) {
        itemsBarView.dataSource = barItems
        itemsBarView.refresh()
    }

    func reload(section: SavedContent.SectionAccessoryIndex) {
        tableView.beginUpdates()
        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadSections(IndexSet(integer: section.rawValue), with: .automatic)
        tableView.endUpdates()
    }

    func reloadItemAt(indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }


}

// MARK: - UITableViewDelegate

extension SavedContentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.selectedCellAt(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == SavedContent.SectionAccessoryIndex.card.rawValue {
            return itemsBarView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == SavedContent.SectionAccessoryIndex.card.rawValue {
            return itemsBarView.frame.height
        }
        return 0
    }


}

// MARK: - HorizontalItemsBarViewDelegate

extension SavedContentViewController: HorizontalItemsBarViewDelegate {

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int) {
        presenter.selectedBarItemAt(index: index)
    }

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didLongTappedItemAt index: Int) {
        let actions: [UIAlertAction] = [
            .init(title: "Видалити", style: .destructive, handler: { [unowned self] (_) in
                self.presenter.deleteFolder(at: index) { [unowned self] in
                    self.itemsBarView.delete(at: index)
                }
            }),

            .init(title: "Змінити", style: .default, handler: { [unowned self] (_) in
                let title = self.itemsBarView.dataSource[safe: index]?.title
                self.newFolderAlert(folderName: title, completion: { [unowned self] (folderName) in
                    self.presenter.updateFolder(at: index, withNewTitle: folderName) { [unowned self] (updatedBarItem) in
                        self.itemsBarView.update(at: index, with: updatedBarItem)
                    }
                })
            }),

            .init(title: "Відмінити", style: .cancel, handler: { (_) in
                Log.debug("Cancel")
            })
        ]
        if presenter.isEditableBarItemAt(index: index) {
            actionSheetAlert(title: nil, message: nil, actions: actions)
        }
    }


}

// MARK: - MapTableViewCellDelegate

extension SavedContentViewController: MapTableViewCellDelegate {

    func mapTableViewCell(_ cell: MapTableViewCell, didUpdateVisibleRectBounds topLeft: CLLocationCoordinate2D?, bottomRight: CLLocationCoordinate2D?) {
        let topLeftRectCoordinate = CoordinateApiModel(latitude: topLeft?.latitude, longitude: topLeft?.longitude)
        let bottomRightRectCoordinate = CoordinateApiModel(latitude: bottomRight?.latitude, longitude: bottomRight?.longitude)
        presenter.fetchMapMarkersInRegionFittedBy(topLeft: topLeftRectCoordinate, bottomRight: bottomRightRectCoordinate) { markers in
            cell.markers = markers
        }
    }

    func openSettingsAction(_ cell: MapTableViewCell) {
        openSettings()
    }


}
