//
//  HorizontalPhotosListTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol HorizontalPhotosListDelegate: class {

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

    
}

// MARK: - UICollectionViewDelegate

extension HorizontalPhotosListTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
        return cell
    }


}


