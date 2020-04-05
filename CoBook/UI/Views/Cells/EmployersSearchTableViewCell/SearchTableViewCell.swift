//
//  EmployersSearchTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol SearchTableViewCellDelegate: class {
    func onSearchTapped(_ cell: SearchTableViewCell)
}

class SearchTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet var searchBar: UISearchBar!

    weak var delegate: SearchTableViewCellDelegate?

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.delegate = self
    }
    
    
}

// MARK: - UISearchBarDelegate
extension SearchTableViewCell: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        delegate?.onSearchTapped(self)
        return false
    }


}
