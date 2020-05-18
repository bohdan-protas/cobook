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

    /// Horizontal items bar view
    private lazy var itemsBarView: HorizontalItemsBarView = {
        let view = HorizontalItemsBarView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 58)), dataSource: presenter.barItems)
        view.delegate = self.presenter
        return view
    }()

    /// pull refresh controll
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.Theme.grayUI
        refreshControl.addTarget(self, action: #selector(refreshAllCardsData(_:)), for: .valueChanged)
        return refreshControl
    }()

    private var searchController: UISearchController!
    private var searchResultsTableController: CardsOverviewSearchResultTableViewController!
    private var searchBar: UISearchBar!

    var presenter: CardsOverviewViewPresenter = CardsOverviewViewPresenter()

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
        presenter.onViewDidLoad()
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
        filterNavigation.modalPresentationStyle = .popover
        filterNavigation.popoverPresentationController?.delegate = self
        filterNavigation.popoverPresentationController?.permittedArrowDirections = .up
        filterNavigation.popoverPresentationController?.barButtonItem = sender

        self.present(controller: filterNavigation, animated: true)
    }

    @objc private func refreshAllCardsData(_ sender: Any) {
        presenter.refreshDataSource()
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

    func reloadItemAt(indexPath: IndexPath) {
        if isSearchActived {
            searchResultsTableController.tableView.reloadRows(at: [indexPath], with: .none)
        } else {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }

    }

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

}

// MARK: - UIPopoverPresentationControllerDelegate

extension CardsOverviewViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }

}

// MARK: - Privates

private extension CardsOverviewViewController {

    func setupLayout() {
        // Table View setup
        tableView.delegate = self
        tableView.refreshControl = refreshControl

        // Search Result Contoller setup
        searchResultsTableController = UIStoryboard.allCards.initiateViewControllerFromType()
        searchResultsTableController.tableView.delegate = self

        // Search Controller setup
        searchController = UISearchController(searchResultsController: searchResultsTableController)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true

        // Search bar setup
        searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .default
        searchBar.barTintColor = UIColor.Theme.blackMiddle
        searchBar.tintColor = UIColor.Theme.blackMiddle
        searchBar.setImage(UIImage(named: "ic_search"), for: .search, state: .normal)
        searchBar.placeholder = "Пошук візитівки"
        searchBar.autocapitalizationType = .none
        searchBar.showsCancelButton = false

        navigationItem.titleView = searchBar
        definesPresentationContext = true
    }


}

// MARK: - UITableViewDelegate

extension CardsOverviewViewController: UITableViewDelegate {

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

        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)

        presenter.updateSearchResult(query: strippedString)
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
        presenter.refreshDataSource()
    }


}

// MARK: - CardItemTableViewCellDelegate

extension CardsOverviewViewController: CardItemTableViewCellDelegate {

    func onSaveCard(cell: CardItemTableViewCell) {
        if isSearchActived {
            if let index = searchResultsTableController.tableView.indexPath(for: cell) {
                presenter.saveCardAt(indexPath: index)
            }
        } else {
            if let index = tableView.indexPath(for: cell) {
                presenter.saveCardAt(indexPath: index)
            }
        }

    }


}

