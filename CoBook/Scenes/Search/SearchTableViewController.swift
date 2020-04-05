//
//  SearchTableViewController.swift
//  CoBook
//
//  Created by protas on 4/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    /// Data model for the table view.
    var previewCards: [CardPreviewModel] = [
        CardPreviewModel(id: 1, image: nil, firstName: "fname0", lastName: "lname0", profession: "profession0", telephone: "+380975305491"),
        CardPreviewModel(id: 1, image: nil, firstName: "fname1", lastName: "lname1", profession: "profession1", telephone: "+380975305492"),
        CardPreviewModel(id: 1, image: nil, firstName: "fname2", lastName: "lname2", profession: "profession2", telephone: "+380975305493"),
        CardPreviewModel(id: 1, image: nil, firstName: "fname3", lastName: "lname3", profession: "profession3", telephone: "+380975305494"),
        CardPreviewModel(id: 1, image: nil, firstName: "fname4", lastName: "lname4", profession: "profession4", telephone: "+380975305495"),
        CardPreviewModel(id: 1, image: nil, firstName: "fname5", lastName: "lname5", profession: "profession5", telephone: "+380975305496"),
        CardPreviewModel(id: 1, image: nil, firstName: "fname6", lastName: "lname6", profession: "profession6", telephone: "+380975305497"),
        CardPreviewModel(id: 1, image: nil, firstName: "fname7", lastName: "lname7", profession: "profession7", telephone: "+380975305498"),
        CardPreviewModel(id: 1, image: nil, firstName: "fname8", lastName: "lname8", profession: "profession8", telephone: "+380975305499"),
    ]

    /// Search controller to help us with filtering items in the table view.
    var searchController: UISearchController!

    /// Search results table view.
    private var resultsTableController: CardsSearchResultTableViewController!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CardPreviewTableViewCell.nib, forCellReuseIdentifier: CardPreviewTableViewCell.identifier)
        tableView.estimatedRowHeight = 96
        tableView.rowHeight = UITableView.automaticDimension

        resultsTableController = storyboard?.initiateViewControllerFromType()
        resultsTableController.tableView.delegate = self

        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self

        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController

        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previewCards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardPreviewTableViewCell.identifier, for: indexPath) as! CardPreviewTableViewCell
        let model = previewCards[indexPath.row]

        cell.proffesionLabel.text = model.profession
        cell.telephoneNumberLabel.text = model.telephone
        cell.companyNameLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"
        cell.titleImageView.setImage(withPath: model.image, placeholderText: "\(model.firstName?.first?.uppercased() ?? "") \(model.lastName?.first?.uppercased() ?? "")")

        return cell
    }



}

// MARK: - UISearchResultsUpdating

extension SearchTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)

        if let resultsController = searchController.searchResultsController as? CardsSearchResultTableViewController {
            resultsController.searchResults = [previewCards.randomElement()!, previewCards.randomElement()!]
            resultsController.tableView.reloadData()
        }

    }


}

// MARK: - UITableViewDelegate

extension SearchTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCard: CardPreviewModel!
//
//        // Check to see which table view cell was selected.
//        if tableView === self.tableView {
//            selectedCard = previewCards[indexPath.row]
//        } else {
//            selectedCard = resultsTableController.searchResults[indexPath.row]
//        }
        tableView.deselectRow(at: indexPath, animated: false)
    }

}

// MARK: - UISearchBarDelegate

extension SearchTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

// MARK: - UISearchControllerDelegate

extension SearchTableViewController: UISearchControllerDelegate {

    func presentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }

    func didPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }

}
