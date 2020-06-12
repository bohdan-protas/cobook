//
//  SearchViewController.swift
//  CoBook
//
//  Created protas on 6/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    var presenter: SearchPresenter

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    private var searchController: UISearchController!
    private var doneBarButtonItem: UIBarButtonItem!

    // MARK: - Initializers

	init(presenter: SearchPresenter) {
        self.presenter = presenter
        super.init(nibName: "SearchViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

	override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter.view = self
        presenter.setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchController.isActive = true
    }

    deinit {
        presenter.view = nil
    }

    // MARK: -  Actions

    @objc func doneAction() {
        presenter.prepareForDismiss()
        searchController.isActive = false
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Loader view

    override func startLoading() {
        activityIndicator.startAnimating()
    }

    override func stopLoading() {
        activityIndicator.stopAnimating()
    }


}

// MARK: - Privates

private extension SearchViewController {

    func setupLayout() {
        tableView.delegate = self
        tableView.allowsMultipleSelection = presenter.isMultiselectEnabled

        self.navigationItem.title = "SearchContent.title".localized
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: UIFont.SFProDisplay_Medium(size: 15),
                                                                        .foregroundColor: UIColor.Theme.greenDark], for: .normal)

        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        if #available(iOS 13.0, *) {
            self.searchController.automaticallyShowsCancelButton = false
        }

        // Search bar setup
        self.searchController.searchBar.barTintColor = UIColor.Theme.grayBG
        self.searchController.searchBar.tintColor = UIColor.Theme.blackMiddle
        self.searchController.searchBar.setImage(UIImage(named: "ic_search"), for: .search, state: .normal)
        self.searchController.searchBar.placeholder = "SearchBar.placeholder.search".localized
        self.searchController.searchBar.autocapitalizationType = .none
        self.searchController.searchBar.showsCancelButton = false
        self.searchController.searchBar.sizeToFit()

        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }


}

// MARK: - SearchView

extension SearchViewController: SearchView {

    func reload() {
        tableView.reloadData()
    }

    func set(dataSource: TableDataSource<SearchCellsConfigurator>?) {
        dataSource?.connect(to: tableView)
    }

    
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectedAt(indexPath: indexPath) { (success) in
            if success {
                tableView.cellForRow(at: indexPath)?.isSelected = true
                if !self.presenter.isMultiselectEnabled {
                    self.doneAction()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        presenter.deselectedAt(indexPath: indexPath) { (success) in
            if success {
                tableView.cellForRow(at: indexPath)?.isSelected = false
            }
        }
    }


}

// MARK: - UISearchControllerDelegate

extension SearchViewController: UISearchControllerDelegate {

    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchBar.showsCancelButton = false
            searchController.searchBar.becomeFirstResponder()
        }
    }


}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: .whitespaces)
        presenter.searchBy(text: strippedString)
    }


}
