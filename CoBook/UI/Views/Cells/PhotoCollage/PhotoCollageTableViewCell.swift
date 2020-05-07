//
//  PhotoCollageTableViewCell.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol PhotoCollageTableViewCellDataSource: class {
    func photoCollage(_ view: PhotoCollageTableViewCell) -> [String?]
}

fileprivate enum Layout {
    static let minimumPhotoItemWidth: CGFloat = 100
    static let photoItemsInset: CGFloat = 4
}

class PhotoCollageTableViewCell: UITableViewCell {

    @IBOutlet var titlePhotoImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var bottomContainerHeight: NSLayoutConstraint!

    weak var dataSource: PhotoCollageTableViewCellDataSource?

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollageItemCollectionViewCell.nib, forCellWithReuseIdentifier: PhotoCollageItemCollectionViewCell.identifier)
    }

    func prepareLayout() {
        titlePhotoImageView.setImage(withPath: self.dataSource?.photoCollage(self).first ?? "", placeholderImage: #imageLiteral(resourceName: "ic_photo_placeholder"))

        let dataSourceCount = dataSource?.photoCollage(self).count ?? 0
        switch dataSourceCount {
        case 0,1:
            bottomContainerHeight.constant = 0
        case 2,3:
            bottomContainerHeight.constant = (self.frame.height * 0.5) - Layout.photoItemsInset
        default:
            bottomContainerHeight.constant = Layout.minimumPhotoItemWidth + Layout.photoItemsInset
        }
        self.layoutIfNeeded()
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate

extension PhotoCollageTableViewCell: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource

extension PhotoCollageTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.dataSource?.photoCollage(self).count ?? 0
        if count != 0 {
            return count - 1
        }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollageItemCollectionViewCell.identifier, for: indexPath) as! PhotoCollageItemCollectionViewCell
        let photoPath = dataSource?.photoCollage(self)[indexPath.item + 1]
        cell.photoImageView.setImage(withPath: photoPath)
        return cell
    }


}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoCollageTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numb = dataSource?.photoCollage(self).count ?? 1
        if numb > 0 { numb -= 1 }
        let width = max(collectionView.frame.width / CGFloat(numb), Layout.minimumPhotoItemWidth)
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }

}
