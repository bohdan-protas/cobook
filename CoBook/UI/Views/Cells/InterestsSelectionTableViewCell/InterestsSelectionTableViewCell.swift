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
    func dataSourceWith(identifier: String?) ->  [InterestModel]
}

class InterestsSelectionTableViewCell: UITableViewCell {

    enum Constants {
        static let spacing: CGFloat = 16
    }

    @IBOutlet var interestsCollectionView: UICollectionView!
    @IBOutlet var interestsCollectionViewFlowLayout: LeftAlignedCollectionViewFlowLayout!

    weak var delegate: InterestsSelectionTableViewCellDelegate?
    weak var dataSource: InterestsSelectionTableViewCellDataSource?
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var leftConftraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var rightConstraint: NSLayoutConstraint!
    @IBOutlet var heightConstraint: NSLayoutConstraint!

    var dataSourceIdentifier: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        interestsCollectionView.register(InterestItemCollectionViewCell.nib, forCellWithReuseIdentifier: InterestItemCollectionViewCell.identifier)
        interestsCollectionView.delegate = self
        interestsCollectionView.dataSource = self

        interestsCollectionViewFlowLayout.estimatedItemSize = .init(width: 50, height: 24)
        interestsCollectionViewFlowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
    }

    func reload() {
        self.interestsCollectionView.reloadData()
    }

    
}

// MARK: - UICollectionViewDataSource

extension InterestsSelectionTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.dataSourceWith(identifier: self.dataSourceIdentifier).count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestItemCollectionViewCell.identifier, for: indexPath) as! InterestItemCollectionViewCell
        let interest = dataSource?.dataSourceWith(identifier: self.dataSourceIdentifier)[safe: indexPath.row]
        cell.titleLabel.text = interest?.title
        cell.setSelected(interest?.isSelected ?? false)
        cell.maxWidth = self.interestsCollectionView.bounds.width
        return cell
    }


}

//// MARK: - UICollectionViewDelegateFlowLayout
//
//extension InterestsSelectionTableViewCell: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //self.sizingCell?.setMaximumCellWidth(collectionView.frame.width)
//        //self.configureCell(self.sizingCell!, forIndexPath: indexPath)
//        return self.sizingCell!.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//    }
//
//
//}

// MARK: - UICollectionViewDelegate

extension InterestsSelectionTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let interest = dataSource?.dataSourceWith(identifier: self.dataSourceIdentifier)[safe: indexPath.row] {
            if interest.isSelected {
                delegate?.interestsSelectionTableViewCell(self, didDeselectInterestAt: indexPath.item)
            } else {
                delegate?.interestsSelectionTableViewCell(self, didSelectInterestAt: indexPath.item)
            }

            let cell = collectionView.cellForItem(at: indexPath) as? InterestItemCollectionViewCell
            cell?.setSelected(dataSource?.dataSourceWith(identifier: self.dataSourceIdentifier)[indexPath.item].isSelected ?? false)
        }

    }


}
