//
//  CardsOverviewViewController.swift
//  CoBook
//
//  Created by protas on 4/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import CoreLocation

class CardsOverviewViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var filterBarButtonItem: UIBarButtonItem!

    var searchController: UISearchController!
    var searchResultsTableController: CardsOverviewSearchResultTableViewController!
    var searchBar: UISearchBar!
    var presenter: CardsOverviewViewPresenter = CardsOverviewViewPresenter()

    /// Horizontal items bar view
     lazy var itemsBarView: HorizontalItemsBarView = {
        let view = HorizontalItemsBarView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 60)), dataSource: presenter.barItems)
        view.delegate = self.self
        return view
    }()

    /// pull refresh controll
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.Theme.grayUI
        refreshControl.addTarget(self, action: #selector(refreshAllCardsData(_:)), for: .valueChanged)
        return refreshControl
    }()

    lazy var bottomLoaderView: BottomLoaderView = {
        let bottomLoader = BottomLoaderView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 50)))
        return bottomLoader
    }()

    var isSearchActived: Bool {
        get {
            return searchController.isActive
        }
    }

    // MARK: - View Lifecycle

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

    @IBAction func filterBarButtonTapped(_ sender: UIBarButtonItem) {
        let filterViewController: FilterViewController = self.storyboard!.initiateViewControllerFromType()
        filterViewController.delegate = self
        let filterNavigation = CustomNavigationController(rootViewController: filterViewController)
        self.presentPanModal(filterNavigation)
        //self.present(controller: filterNavigation, animated: true)
    }

    @objc private func refreshAllCardsData(_ sender: Any) {
        presenter.setup(useLoader: false)
    }

    @objc func onDidReceiveCardSaveOperationHandler(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Any], let cardID = data[Notification.Key.cardID] as? Int, let controllerID = data[Notification.Key.controllerID] as? String {
            if CardsOverviewViewController.describing != controllerID {
                self.presenter.updateCardItem(id: cardID, withSavedFlag: true)
                self.reload()
            }
        }
    }

    @objc func onDidReceiveCardUnsaveOperationHandler(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Any], let cardID = data[Notification.Key.cardID] as? Int, let controllerID = data[Notification.Key.controllerID] as? String {
            if CardsOverviewViewController.describing != controllerID {
                self.presenter.updateCardItem(id: cardID, withSavedFlag: false)
                self.reload()
            }
        }
    }


}

// MARK: - CardsOverviewView

extension CardsOverviewViewController: CardsOverviewView {

    func showBottomLoaderView() {
        tableView.tableFooterView = bottomLoaderView
    }

    func hideBottomLoaderView() {
        tableView.tableFooterView = nil
    }

    func set(dataSource: DataSource<CardsOverviewViewDataSourceConfigurator>?) {
        dataSource?.connect(to: self.tableView)
    }

    func set(searchDataSource: DataSource<CardsOverviewViewDataSourceConfigurator>?) {
        searchDataSource?.connect(to: searchResultsTableController.tableView)
    }

    func reload(section: CardsOverview.SectionAccessoryIndex) {
        tableView.beginUpdates()
        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadSections(IndexSet(integer: section.rawValue), with: .automatic)
        tableView.endUpdates()
    }

    func reload() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    func reloadSearch(resultText title: String) {
        searchResultsTableController.set(resultsLabel: title)
        searchResultsTableController.tableView.reloadData()
    }

    func goToBusinessCardDetails(presenter: BusinessCardDetailsPresenter?) {
        let businessCardDetailsViewController: BusinessCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
        businessCardDetailsViewController.presenter = presenter
        self.navigationController?.pushViewController(businessCardDetailsViewController, animated: true)
        searchController.isActive = false
    }

    func goToPersonalCardDetails(presenter: PersonalCardDetailsPresenter?) {
        let personalCardDetailsViewController: PersonalCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
        personalCardDetailsViewController.presenter = presenter
        self.navigationController?.pushViewController(personalCardDetailsViewController, animated: true)
        searchController.isActive = false
    }

    func goToArticleDetails(presenter: ArticleDetailsPresenter?) {
        let controller: ArticleDetailsViewController = UIStoryboard.post.initiateViewControllerFromType()
        controller.presenter = presenter
        let navigation = CustomNavigationController(rootViewController: controller)
        self.presentPanModal(navigation)
    }

}

// MARK: - Privates

private extension CardsOverviewViewController {

    func setupLayout() {
        // Table View setup
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.estimatedRowHeight = 140

        // Search Result Contoller setup
        searchResultsTableController = UIStoryboard.allCards.initiateViewControllerFromType()
        searchResultsTableController.tableView.delegate = self

        // Search Controller setup
        searchController = UISearchController(searchResultsController: searchResultsTableController)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = true

        // Search bar setup
        searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .default
        searchBar.barTintColor = UIColor.Theme.blackMiddle
        searchBar.tintColor = UIColor.Theme.blackMiddle
        searchBar.setImage(UIImage(named: "ic_search"), for: .search, state: .normal)
        searchBar.placeholder = "CardOverview.search.placeholder".localized
        searchBar.autocapitalizationType = .none
        searchBar.showsCancelButton = false

        navigationItem.titleView = searchBar
        definesPresentationContext = true
    }


}

// MARK: - HorizontalItemsBarViewDelegate

extension CardsOverviewViewController: HorizontalItemsBarViewDelegate {

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int) {
        presenter.selectedBarItemAt(index: index)
    }


}


// MARK: - UITableViewDelegate

extension CardsOverviewViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tableView:
            presenter.cellWillDisplayAt(indexPath: indexPath)
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case self.tableView:
            presenter.selectedCellAt(indexPath: indexPath)
        case searchResultsTableController.tableView:
            presenter.selectedSearchCellAt(indexPath: indexPath)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
        case self.tableView:
            return itemsBarView
        default:
            return UIView()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case self.tableView:
            if section == 1 {
                return itemsBarView.frame.height
            }
            fallthrough
        default:
            return 0
        }
    }


}

// MARK: - UISearchBarDelegate

extension CardsOverviewViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }


}

// MARK: - UISearchResultsUpdating

extension CardsOverviewViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        presenter.fetchSearchResult(query: strippedString)
    }


}

// MARK: - UISearchControllerDelegate

extension CardsOverviewViewController: UISearchControllerDelegate {

    func willPresentSearchController(_ searchController: UISearchController) {
        searchBar.setShowsCancelButton(true, animated: true)
        self.navigationItem.rightBarButtonItem = nil
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        searchBar.setShowsCancelButton(false, animated: true)
        navigationItem.rightBarButtonItems = [filterBarButtonItem]
    }


}

// MARK: - FilterViewControllerDelegate

extension CardsOverviewViewController: FilterViewControllerDelegate {

    func didFilterChanged(_ viewController: FilterViewController) {
        presenter.setup(useLoader: true)
    }


}

// MARK: - CardItemTableViewCellDelegate

extension CardsOverviewViewController: CardItemTableViewCellDelegate {

    func onSaveCardWithOptions(cell: CardItemTableViewCell) {
        guard let index = tableView.indexPath(for: cell) else {
            return
        }

        presenter.fetchUserFolders { [unowned self] (items) in
            var actions: [UIAlertAction] = []

            // general list
            actions.append(UIAlertAction(title: "AlertAction.generalList.title".localized, style: .default, handler: { _ in
                self.presenter.saveCardAt(indexPath: index, toFolder: nil, completion: { isSuccess in
                    if isSuccess { cell.saveButton.isSelected.toggle() }
                })
            }))

            // current stored folders
            let folderSavingActions: [UIAlertAction] = items.compactMap { folder in
                UIAlertAction.init(title: folder.title, style: .default, handler: { [unowned self] _ in
                    self.presenter.saveCardAt(indexPath: index, toFolder: folder.id, completion: { isSuccess in
                        if isSuccess { cell.saveButton.isSelected.toggle() }
                    })
                })
            }
            actions.append(contentsOf: folderSavingActions)

            // New list
            actions.append(UIAlertAction(title: "AlertAction.createNewList.title".localized, style: .default, handler: { _ in
                self.newFolderAlert(folderName: nil) { (folderTitle) in
                    self.presenter.createFolder(title: folderTitle) { (folder) in
                        self.presenter.saveCardAt(indexPath: index, toFolder: folder.index, completion: { isSuccess in
                            if isSuccess { cell.saveButton.isSelected.toggle() }
                        })
                    }
                }
            }))

            // Calcel action
            actions.append(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))

            self.actionSheetAlert(title: "AlertAction.saveTo".localized, message: nil, actions: actions)
        }
    }

    func onSaveCard(cell: CardItemTableViewCell) {
        if isSearchActived {
            if let index = searchResultsTableController.tableView.indexPath(for: cell) {
                presenter.saveCardAt(indexPath: index, toFolder: nil, completion: { isSuccess in
                    if isSuccess { cell.saveButton.isSelected.toggle() }
                })
            }
        } else {
            if let index = tableView.indexPath(for: cell) {
                presenter.saveCardAt(indexPath: index, toFolder: nil, completion: { isSuccess in
                    if isSuccess { cell.saveButton.isSelected.toggle() }
                })
            }
        }
    }


}

// MARK: - MapTableViewCellDelegate

extension CardsOverviewViewController: MapTableViewCellDelegate {

    func mapTableViewCell(_ cell: MapTableViewCell, didUpdateVisibleRectBounds topLeft: CLLocationCoordinate2D?, bottomRight: CLLocationCoordinate2D?) {
        let topLeftRectCoordinate = CoordinateApiModel(latitude: topLeft?.latitude, longitude: topLeft?.longitude)
        let bottomRightRectCoordinate = CoordinateApiModel(latitude: bottomRight?.latitude, longitude: bottomRight?.longitude)
        presenter.fetchMapMarkersInRegionFittedBy(topLeft: topLeftRectCoordinate, bottomRight: bottomRightRectCoordinate) { markers in
            cell.markers = markers
        }
    }

    func openSettingsAction(_ cell: MapTableViewCell) {
        openSettingsAlert()
    }


}

