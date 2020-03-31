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

    enum Constants {
        static let spacing: CGFloat = 16
    }

    @IBOutlet var interestsCollectionView: UICollectionView!
    @IBOutlet var interestsCollectionViewFlowLayout: LeftAlignedCollectionViewFlowLayout!

    weak var delegate: InterestsSelectionTableViewCellDelegate?
    var dataSource: [CreateCard.InterestItem] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        interestsCollectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        interestsCollectionView.register(InterestItemCollectionViewCell.nib, forCellWithReuseIdentifier: InterestItemCollectionViewCell.identifier)
        interestsCollectionView.delegate = self
        interestsCollectionView.dataSource = self

        interestsCollectionViewFlowLayout.estimatedItemSize = .init(width: 50, height: 24)
        interestsCollectionViewFlowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
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
        cell.setSelected(dataSource[indexPath.row].isSelected)
        cell.maxWidth = self.interestsCollectionView.bounds.width
        return cell
    }


}

// MARK: - UICollectionViewDelegate
extension InterestsSelectionTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if dataSource[indexPath.row].isSelected {
            dataSource[safe: indexPath.item]?.isSelected = false
            self.delegate?.interestsSelectionTableViewCell(self, didDeselectInterestAt: indexPath.item)
        } else {
            dataSource[safe: indexPath.item]?.isSelected = true
            self.delegate?.interestsSelectionTableViewCell(self, didSelectInterestAt: indexPath.item)
        }

        let cell = collectionView.cellForItem(at: indexPath) as? InterestItemCollectionViewCell
        cell?.setSelected(dataSource[indexPath.item].isSelected)
    }


}



