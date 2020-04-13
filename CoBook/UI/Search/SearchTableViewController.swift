//
//  SearchTableViewController.swift
//  CoBook
//
//  Created by protas on 4/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchTableViewControllerDelegate: class {
    func searchTableViewController(_ controller: SearchTableViewController, didSelected item: EmployeeModel?)
}

class SearchTableViewController: UITableViewController, AlertDisplayableView {

    /// Data model for the table view.
    var previewCards = [EmployeeModel]()

    /// Current search request
    private var pendingRequestWorkItem: DispatchWorkItem?

    /// Search bar
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Пошук працівників"
        searchBar.showsCancelButton = true
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        return searchBar
    }()

    weak var delegate: SearchTableViewControllerDelegate?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        clearsSelectionOnViewWillAppear = true
        tableView.register(CardPreviewTableViewCell.nib, forCellReuseIdentifier: CardPreviewTableViewCell.identifier)

        // Place the search bar in the navigation bar.
        navigationItem.titleView = searchBar
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previewCards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardPreviewTableViewCell.identifier, for: indexPath) as! CardPreviewTableViewCell
        let model = previewCards[indexPath.row]

        cell.proffesionLabel.text = model.practiceType?.title
        cell.telephoneNumberLabel.text = model.telephone
        cell.companyNameLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"
        cell.titleImageView.setTextPlaceholderImage(withPath: model.avatar, placeholderText: model.nameAbbreviation)

        return cell
    }


}

// MARK: - UITableViewDelegate

extension SearchTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.searchTableViewController(self, didSelected: previewCards[safe: indexPath.row])
        dismiss(animated: true, completion: nil)
    }


}

// MARK: - UISearchBarDelegate

extension SearchTableViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()

        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)


        let requestWorkItem = DispatchWorkItem { [weak self] in
            APIClient.default.searchEmployee(searchQuery: strippedString) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let response):
                    strongSelf.previewCards = response?.compactMap { EmployeeModel(userId: $0.userId,
                                                                                   cardId: nil,
                                                                                   firstName: $0.firstName,
                                                                                   lastName: $0.lastName,
                                                                                   avatar: $0.avatar?.sourceUrl,
                                                                                   position: $0.position,
                                                                                   telephone: $0.telephone?.number,
                                                                                   practiceType: PracticeModel(id: $0.practiceType?.id, title: $0.practiceType?.title)) } ?? []
                    strongSelf.tableView.reloadData()
                case .failure(let error):
                    strongSelf.errorAlert(message: error.localizedDescription)
                }
            }
        }

        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem)
    }


}
