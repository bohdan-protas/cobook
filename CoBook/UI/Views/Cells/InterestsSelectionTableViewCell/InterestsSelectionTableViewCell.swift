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

protocol InterestsSelectionTableViewCellDataSource: class {
    var interests: [InterestModel] { get set }
}

class InterestsSelectionTableViewCell: UITableViewCell {

    enum Constants {
        static let spacing: CGFloat = 16
    }

    @IBOutlet var interestsCollectionView: UICollectionView!
    @IBOutlet var interestsCollectionViewFlowLayout: LeftAlignedCollectionViewFlowLayout!

    weak var delegate: InterestsSelectionTableViewCellDelegate?
    weak var dataSource: InterestsSelectionTableViewCellDataSource?

    override func awakeFromNib() {
        super.awakeFromNib()

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
        return dataSource?.interests.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestItemCollectionViewCell.identifier, for: indexPath) as! InterestItemCollectionViewCell
        let interest = dataSource?.interests[safe: indexPath.row]
        cell.titleLabel.text = interest?.title
        cell.setSelected(interest?.isSelected ?? false)
        cell.maxWidth = self.interestsCollectionView.bounds.width
        return cell
    }


}

// MARK: - UICollectionViewDelegate
extension InterestsSelectionTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let interest = dataSource?.interests[safe: indexPath.row] {
            if interest.isSelected {
                dataSource?.interests[safe: indexPath.item]?.isSelected = false
                delegate?.interestsSelectionTableViewCell(self, didDeselectInterestAt: indexPath.item)
            } else {
                dataSource?.interests[safe: indexPath.item]?.isSelected = true
                delegate?.interestsSelectionTableViewCell(self, didSelectInterestAt: indexPath.item)
            }

            let cell = collectionView.cellForItem(at: indexPath) as? InterestItemCollectionViewCell
            cell?.setSelected(dataSource?.interests[indexPath.item].isSelected ?? false)
        }

    }


}



