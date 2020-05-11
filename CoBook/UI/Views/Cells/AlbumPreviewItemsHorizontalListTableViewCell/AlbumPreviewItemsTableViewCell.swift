//
//  AlbumPreviewItemsTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/30/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol AlbumPreviewItemsViewDelegate: class {
    func albumPreviewItemsView(_ view: AlbumPreviewItemsTableViewCell, didSelectedAt indexPath: IndexPath, dataSourceID: String?)
}

protocol AlbumPreviewItemsViewDataSource: class {
    func albumPreviewItemsView(_ view: AlbumPreviewItemsTableViewCell, dataSourceID: String?) -> [AlbumPreview.Item]
}

class AlbumPreviewItemsTableViewCell: UITableViewCell {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    weak var delegate: AlbumPreviewItemsViewDelegate?
    weak var dataSource: AlbumPreviewItemsViewDataSource?

    var dataSourceID: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(AlbumPreviewItemCollectionViewCell.nib, forCellWithReuseIdentifier: AlbumPreviewItemCollectionViewCell.identifier)
    }
    
    
}

// MARK: - UICollectionViewDataSource

extension AlbumPreviewItemsTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.albumPreviewItemsView(self, dataSourceID: dataSourceID).count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumPreviewItemCollectionViewCell.identifier, for: indexPath) as! AlbumPreviewItemCollectionViewCell
        if let dataSourceItem = dataSource?.albumPreviewItemsView(self, dataSourceID: dataSourceID)[safe: indexPath.item] {
            switch dataSourceItem {
            case .add(let model):
                cell.titleImageView.setImage(withPath: model.imagePath)
                cell.textLabel.text = model.title
                cell.textLabel.textColor = UIColor.Theme.greenDark
                cell.addItemIndicator.isHidden = false
            case .view(let model):
                cell.titleImageView.setImage(withPath: model.avatarPath)
                cell.textLabel.text = model.title
                cell.textLabel.textColor = UIColor.Theme.blackMiddle
                cell.addItemIndicator.isHidden = true
            case .showMore:
                cell.arrowIndicatorImageView.isHidden = false
                cell.titleImageView.image = nil
                cell.textLabel.text = "Показати всі"
                cell.textLabel.textColor = UIColor.Theme.greenDark
                cell.addItemIndicator.isHidden = true
            }
        }
        return cell
    }


}

// MARK: - UICollectionViewDelegate

extension AlbumPreviewItemsTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.albumPreviewItemsView(self, didSelectedAt: indexPath, dataSourceID: dataSourceID)
    }


}
