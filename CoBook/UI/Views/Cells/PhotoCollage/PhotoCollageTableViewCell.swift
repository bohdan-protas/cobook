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

protocol PhotoCollageTableViewCellDelegate: class {
    func photoCollage(_ view: PhotoCollageTableViewCell, selectedPhotoAt index: Int)
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
    weak var delegate: PhotoCollageTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollageItemCollectionViewCell.nib, forCellWithReuseIdentifier: PhotoCollageItemCollectionViewCell.identifier)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleImageSelected))
        titlePhotoImageView.isUserInteractionEnabled = true
        titlePhotoImageView.addGestureRecognizer(tapGesture)
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

    @objc func titleImageSelected() {
        delegate?.photoCollage(self, selectedPhotoAt: 0)
    }
    
}

// MARK: - UICollectionViewDelegate

extension PhotoCollageTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.photoCollage(self, selectedPhotoAt: indexPath.item + 1)
    }

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
        cell.photoImageView.setImage(withPath: photoPath, placeholderImage: #imageLiteral(resourceName: "ic_photo_placeholder"))
        return cell
    }


}

// MARK: - UICollectionViewDataSource

extension PhotoCollageTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numb = dataSource?.photoCollage(self).count ?? 1
        if numb > 0 { numb -= 1 }
        let width = max(collectionView.frame.width / CGFloat(numb), Layout.minimumPhotoItemWidth)
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }

}

