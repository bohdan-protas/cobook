//
//  CardsSearchResultTableViewController.swift
//  CoBook
//
//  Created by protas on 4/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CardsSearchResultTableViewController: UITableViewController {

    var searchResults = [CardPreviewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 96
        tableView.rowHeight = UITableView.automaticDimension

        clearsSelectionOnViewWillAppear = true
        tableView.register(CardPreviewTableViewCell.nib, forCellReuseIdentifier: CardPreviewTableViewCell.identifier)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardPreviewTableViewCell.identifier, for: indexPath) as! CardPreviewTableViewCell
        let model = searchResults[indexPath.row]

        cell.proffesionLabel.text = model.profession
        cell.telephoneNumberLabel.text = model.telephone
        cell.companyNameLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"
        cell.titleImageView.setImage(withPath: model.image, placeholderText: "\(model.firstName?.first?.uppercased() ?? "") \(model.lastName?.first?.uppercased() ?? "")")

        return cell
    }


}
