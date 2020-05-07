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

class PhotoCollageTableViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!

    weak var dataSource: PhotoCollageTableViewCellDataSource?

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollageItemCollectionViewCell.nib, forCellWithReuseIdentifier: PhotoCollageItemCollectionViewCell.identifier)
    }
    
}

// MARK: - UICollectionViewDelegate

extension PhotoCollageTableViewCell: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource

extension PhotoCollageTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.photoCollage(self).count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollageItemCollectionViewCell.identifier, for: indexPath) as! PhotoCollageItemCollectionViewCell
        return cell
    }


}
