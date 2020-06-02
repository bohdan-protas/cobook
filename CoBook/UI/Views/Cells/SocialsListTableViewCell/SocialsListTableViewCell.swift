//
//  SocialsListTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol SocialsListTableViewCellDelegate: class {
    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didSelectedSocialItem item: Social.ListItem)
    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didLongPresseddOnItem value: Social.Model, at indexPath: IndexPath)
}

protocol SocialsListTableViewCellDataSource: class {
    var socials: [Social.ListItem] { get set }
}

class SocialsListTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet var collectionView: UICollectionView!

    var isEditable: Bool = false {
        didSet {
            if isEditable {
                if dataSource?.socials.isEmpty ?? false {
                    self.dataSource?.socials = [.add]
                } else {
                    switch dataSource?.socials.last {
                    case .view:
                        self.dataSource?.socials.append(.add)
                    default:
                        break
                    }
                }
            }
            self.collectionView.reloadData()
        }
    }

    weak var delegate: SocialsListTableViewCellDelegate?
    weak var dataSource: SocialsListTableViewCellDataSource?

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
            if let item = dataSource?.socials[safe: indexPath.item] {
                switch item {
                case .view(let social):
                    if isEditable {
                        delegate?.socialsListTableViewCell(self, didLongPresseddOnItem: social, at: indexPath)
                    }
                default:
                    break
                }
            }
        }
    }

    func create(socialListItem: Social.ListItem) {
        if isEditable && collectionView.numberOfItems(inSection: 0) >= 1 {
            collectionView.performBatchUpdates({
                self.dataSource?.socials.insert(socialListItem, at: collectionView.numberOfItems(inSection: 0)-1)
                self.collectionView.insertItems(at: [IndexPath(item: collectionView.numberOfItems(inSection: 0)-1, section: 0)])
            }) { (finished) in

            }
        }
    }

    func updateAt(indexPath: IndexPath, with item: Social.ListItem) {
        self.dataSource?.socials[safe: indexPath.row] = item
        collectionView.reloadItems(at: [indexPath])
    }

    func deleteAt(indexPath: IndexPath) {
        collectionView.performBatchUpdates({
            self.dataSource?.socials.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
        }) { (finished) in

        }
    }


}

// MARK: - UICollectionViewDelegate
extension SocialsListTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource?.socials[safe: indexPath.item] {

            switch item {
            case .view:
                if !isEditable, let item = dataSource?.socials[safe: indexPath.item] {
                    delegate?.socialsListTableViewCell(self, didSelectedSocialItem: item)
                }
            case .add:
                if isEditable, let item = dataSource?.socials[safe: indexPath.item] {
                    delegate?.socialsListTableViewCell(self, didSelectedSocialItem: item)
                }
            }

        }
    }


}

// MARK: - UICollectionViewDataSource
extension SocialsListTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.socials.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialListItemCollectionViewCell.identifier, for: indexPath) as! SocialListItemCollectionViewCell
        if let item = dataSource?.socials[indexPath.item] {
             cell.configure(with: item)
        }
        return cell
    }


}
