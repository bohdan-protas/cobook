//
//  HorizontalPhotosListTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol HorizontalPhotosListDelegate: class {
    func didAddNewPhoto(_ cell: HorizontalPhotosListTableViewCell)
}

protocol HorizontalPhotosListDataSource: class {
    var photos: [EditablePhotoListItem] { get set }
}

class HorizontalPhotosListTableViewCell: UITableViewCell {

    @IBOutlet var photosCollectionView: UICollectionView!

    /// actions delegation
    weak var delegate: HorizontalPhotosListDelegate?

    /// data source delegation
    weak var dataSource: HorizontalPhotosListDataSource?

    var isEditable: Bool = false {
        didSet {
            if isEditable {
                if dataSource?.photos.isEmpty ?? false {
                    self.dataSource?.photos = [.add]
                } else {
                    switch dataSource?.photos.last {
                    case .view:
                        self.dataSource?.photos.append(.add)
                    default:
                        break
                    }
                }
            }
            self.photosCollectionView.reloadData()
        }
    }

    // MARK: - View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self

        photosCollectionView.register(EditablePhotoListItemCollectionViewCell.nib, forCellWithReuseIdentifier: EditablePhotoListItemCollectionViewCell.identifier)
        photosCollectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }

    // MARK: - Public

    func create(socialListItem: EditablePhotoListItem) {
        if isEditable && photosCollectionView.numberOfItems(inSection: 0) >= 1 {
            photosCollectionView.performBatchUpdates({
                self.dataSource?.photos.insert(socialListItem, at: photosCollectionView.numberOfItems(inSection: 0)-1)
                self.photosCollectionView.insertItems(at: [IndexPath(item: photosCollectionView.numberOfItems(inSection: 0)-1, section: 0)])
            }) { (finished) in
                if let count = self.dataSource?.photos.count {
                    self.photosCollectionView.scrollToItem(at: IndexPath(item: count-1, section: 0), at: .right, animated: true)
                }

            }
        }
    }

//    func updateAt(indexPath: IndexPath, with item: Social.ListItem) {
//        self.dataSource?.socials[safe: indexPath.row] = item
//        collectionView.reloadItems(at: [indexPath])
//    }
//
//    func deleteAt(indexPath: IndexPath) {
//        collectionView.performBatchUpdates({
//            self.dataSource?.socials.remove(at: indexPath.item)
//            self.collectionView.deleteItems(at: [indexPath])
//        }) { (finished) in
//
//        }
//    }
    
}

// MARK: - UICollectionViewDelegate

extension HorizontalPhotosListTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource?.photos[safe: indexPath.item]

        switch model {
        case .some(let value):
            switch value {
            case .view:
                break
            case .add:
                delegate?.didAddNewPhoto(self)
            }
        case .none: break
        }

    }


}

// MARK: - UICollectionViewDelegateFlowLayout

extension HorizontalPhotosListTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }

}

// MARK: - UICollectionViewDataSource

extension HorizontalPhotosListTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.photos.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditablePhotoListItemCollectionViewCell.identifier, for: indexPath) as! EditablePhotoListItemCollectionViewCell
        let model = dataSource?.photos[indexPath.item]

        switch model {
        case .some(let value):
            switch value {
            case .view(let imagePath, let imageData):
                if let imageData = imageData, let image = UIImage(data: imageData) {
                    cell.titleImageView.image = image
                } else {
                    cell.titleImageView.setImage(withPath: imagePath)
                }
                cell.addPhotoPlaceholderView.isHidden = true
            case .add:
                cell.addPhotoPlaceholderView.isHidden = false
            }
        case .none:
            break
        }
        
        return cell
    }


}


