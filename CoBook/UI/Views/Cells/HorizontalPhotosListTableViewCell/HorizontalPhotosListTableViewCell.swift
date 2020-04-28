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
    func didUpdatePhoto(_ cell: HorizontalPhotosListTableViewCell, at indexPath: IndexPath)
    func didDeletePhoto(_ cell: HorizontalPhotosListTableViewCell, at indexPath: IndexPath)
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

        photosCollectionView.register(AddPhotoListItemCollectionViewCell.nib, forCellWithReuseIdentifier: AddPhotoListItemCollectionViewCell.identifier)
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

    func deleteAt(indexPath: IndexPath) {
        photosCollectionView.performBatchUpdates({
            self.dataSource?.photos.remove(at: indexPath.item)
            self.photosCollectionView.deleteItems(at: [indexPath])
        }) { (finished) in

        }
    }

    func updateAt(indexPath: IndexPath, with item: EditablePhotoListItem) {
        self.dataSource?.photos[safe: indexPath.row] = item
        photosCollectionView.reloadItems(at: [indexPath])
    }


}

// MARK: - UICollectionViewDelegate

extension HorizontalPhotosListTableViewCell: UICollectionViewDelegate {

    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let item = dataSource?.photos[safe: indexPath.item], isEditable else {
            return nil
        }

        switch item {
        case .view:
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action in

                let edit = UIAction(title: "Змінити", image: UIImage(systemName: "arrow.clockwise"), identifier: nil, handler: { action in
                    self.delegate?.didUpdatePhoto(self, at: indexPath)
                })

                let delete = UIAction(title: "Видалити", image: UIImage(systemName: "trash.fill"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: { action in
                    self.delegate?.didDeletePhoto(self, at: indexPath)
                })

                return UIMenu(title: "Редагування фото", children: [edit, delete])
            }
            return configuration

        case .add:
            return nil
        }
    }

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
        switch dataSource?.photos[indexPath.item] {
        case .some(let value):
            switch value {

            case .view(let imagePath, _):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditablePhotoListItemCollectionViewCell.identifier, for: indexPath) as! EditablePhotoListItemCollectionViewCell
                cell.titleImageView.setImage(withPath: imagePath)
                return cell

            case .add:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoListItemCollectionViewCell.identifier, for: indexPath) as! AddPhotoListItemCollectionViewCell
                return cell
            }
        case .none:
            return UICollectionViewCell()
        }

    }


}


