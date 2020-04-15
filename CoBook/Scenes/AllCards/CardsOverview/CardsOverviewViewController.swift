//
//  CardsOverviewViewController.swift
//  CoBook
//
//  Created by protas on 4/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import CoreLocation

class CardsOverviewViewController: BaseViewController, CardsOverviewView {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var filterBarButtonItem: UIBarButtonItem!

    private lazy var itemsBarView: HorizontalItemsBarView = {
        let view = HorizontalItemsBarView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 58)), dataSource: presenter.barItems)
        view.delegate = self.presenter
        return view
    }()

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
    var dataSource: TableDataSource<CardsOverviewViewDataSourceConfigurator>?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter.attachView(self)
        presenter.onViewDidLoad()
    }

    deinit {
        presenter.detachView()
    }

    // MARK: Actions

    @IBAction func filterBarButtonTapped(_ sender: Any) {
        let filterViewController: FilterViewController = self.storyboard!.initiateViewControllerFromType()
        filterViewController.delegate = self

        let navigationController = CustomNavigationController(rootViewController: filterViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve

        self.present(controller: navigationController, animated: true)
    }

    @objc private func refreshAllCardsData(_ sender: Any) {
        presenter.refreshDataSource()
    }

    // MARK: - CardsOverviewView

    func set(dataSource: DataSource<CardsOverviewViewDataSourceConfigurator>?) {
        dataSource?.connect(to: self.tableView)
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

    func set(searchDataSource: DataSource<CardsOverviewViewDataSourceConfigurator>?) {
        searchDataSource?.connect(to: searchResultsTableController.tableView)
    }

    func reloadSearch(resultText title: String) {
        searchResultsTableController.set(resultsLabel: title)
        searchResultsTableController.tableView.reloadData()
    }

    func openSettings() {
        let alertController = UIAlertController (title: nil, message: "Перейти в налаштування?", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Налаштування", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    Log.debug("Settings opened")
                })
            }
        }

        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Відмінити", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }


}

// MARK: - Privates

private extension CardsOverviewViewController {

    func setupLayout() {
        tableView.delegate = self
        tableView.refreshControl = refreshControl

        self.searchResultsTableController = UIStoryboard.allCards.initiateViewControllerFromType()

        searchController = UISearchController(searchResultsController: searchResultsTableController)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true

        searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .default
        searchBar.searchTextField.backgroundColor = .white
        searchBar.barTintColor = UIColor.Theme.blackMiddle
        searchBar.tintColor = UIColor.Theme.blackMiddle
        searchBar.setImage(UIImage(named: "ic_search"), for: .search, state: .normal)
        searchBar.placeholder = "Пошук професії, виду діяльності"
        searchBar.autocapitalizationType = .none
        searchBar.showsCancelButton = false

        navigationItem.titleView = searchBar
        definesPresentationContext = true
    }


}

// MARK: - UITableViewDelegate

extension CardsOverviewViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tableView:
            break
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


