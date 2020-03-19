//
//  SocialsListTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol SocialsListTableViewCellDelegate: class {
    /// Called when user selected social item
    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didSelectedSocialItem item: Social.ListItem)
    /// Called when user longpressed social item
    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didLongPresseddOnItem value: Social.Model, at indexPath: IndexPath)
}

class SocialsListTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet var collectionView: UICollectionView!

    var isEditable: Bool = false
    var dataSource: [Social.ListItem] = []
    weak var delegate: SocialsListTableViewCellDelegate?

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SocialListItemCollectionViewCell.nib, forCellWithReuseIdentifier: SocialListItemCollectionViewCell.identifier)

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
    }

    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }

        let location = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: location) {

            if let item = dataSource[safe: indexPath.item] {
                switch item {
                case .view(let social):
                    if isEditable {
                        delegate?.socialsListTableViewCell(self, didLongPresseddOnItem: social, at: indexPath)
                    }
                default:
                    break
                }
            }


        } else {
            Log.debug("Couldn't find longpressed item indexPath")
        }
    }

    func deleteAt(indexPath: IndexPath) {
        collectionView.performBatchUpdates({
            self.dataSource.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
        }) { (finished) in

        }
    }

    func fill(items: [Social.ListItem], isEditable: Bool) {
        self.isEditable = isEditable
        self.dataSource = items

        if isEditable {
            if items.isEmpty {
                self.dataSource = [.add]
            } else {
                switch dataSource.last {
                case .view:
                    self.dataSource.append(.add)
                default:
                    break
                }
            }
        }
        self.collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDelegate
extension SocialsListTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource[safe: indexPath.item] {

            switch item {
            case .view:
                if !isEditable, let item = dataSource[safe: indexPath.item] {
                    delegate?.socialsListTableViewCell(self, didSelectedSocialItem: item)
                }
            case .add:
                if isEditable, let item = dataSource[safe: indexPath.item] {
                    delegate?.socialsListTableViewCell(self, didSelectedSocialItem: item)
                }
            }

        }
    }


}

// MARK: - UICollectionViewDataSource
extension SocialsListTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = dataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialListItemCollectionViewCell.identifier, for: indexPath) as! SocialListItemCollectionViewCell

        switch item {
        case .view(let social):
            cell.socialTitleLabel.text = social.title
            cell.socialImageView.image = social.type.image
        case .add:
            cell.socialImageView.image = UIImage(named: "ic_add_item")
            cell.socialTitleLabel.text = "Додати"
        }
        return cell
    }


}
