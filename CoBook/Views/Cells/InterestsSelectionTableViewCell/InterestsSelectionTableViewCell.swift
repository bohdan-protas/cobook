//
//  InterestsSelectionTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol InterestsSelectionTableViewCellDelegate: class {
    func interestsSelectionTableViewCell(_ cell: InterestsSelectionTableViewCell, didSelectInterestAt index: Int)
    func interestsSelectionTableViewCell(_ cell: InterestsSelectionTableViewCell, didDeselectInterestAt index: Int)
}

class InterestsSelectionTableViewCell: UITableViewCell {

    @IBOutlet var interestsCollectionView: UICollectionView!
    weak var delegate: InterestsSelectionTableViewCellDelegate?
    var dataSource: [PersonalCard.Interest] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        interestsCollectionView.register(InterestItemCollectionViewCell.nib, forCellWithReuseIdentifier: InterestItemCollectionViewCell.identifier)
        interestsCollectionView.delegate = self
        interestsCollectionView.dataSource = self
        interestsCollectionView.allowsMultipleSelection = true

        // Set up the flow layout's cell alignment:
        let flowLayout = interestsCollectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        flowLayout?.horizontalAlignment = .left
        flowLayout?.estimatedItemSize = .init(width: 100, height: 24)
    }

    
}

// MARK: - UICollectionViewDataSource
extension InterestsSelectionTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestItemCollectionViewCell.identifier, for: indexPath) as! InterestItemCollectionViewCell
        cell.titleLabel.text = dataSource[indexPath.row].title
        cell.isSelected = dataSource[indexPath.row].isSelected
        return cell
    }


}

// MARK: - UICollectionViewDelegate
extension InterestsSelectionTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.interestsSelectionTableViewCell(self, didSelectInterestAt: indexPath.item)

        collectionView.cellForItem(at: indexPath)?.isSelected = true
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.delegate?.interestsSelectionTableViewCell(self, didDeselectInterestAt: indexPath.item)
        collectionView.cellForItem(at: indexPath)?.isSelected = false
    }

}
