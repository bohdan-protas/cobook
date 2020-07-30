//
//  NotificationItemTableViewCell.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol NotificationItemCellDelegate: class {
    func notificationItemCell(_ cell: NotificationItemTableViewCell, didTappedPhoto atItem: Int)
}

protocol NotificationItemCellDataSource: class {
    func photosList(_ cell: NotificationItemTableViewCell, associatedIndexPath: IndexPath?) -> [String]
}

class NotificationItemTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: DesignableImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var photosContainerView: UIView!
    @IBOutlet var photosCollectionView: UICollectionView!
    
    var associatedIndexPath: IndexPath?
    weak var delegate: NotificationItemCellDelegate?
    weak var dataSource: NotificationItemCellDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        pageControl.hidesForSinglePage = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: photosCollectionView.frame.width, height: photosCollectionView.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        photosCollectionView.collectionViewLayout = layout
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
 
extension NotificationItemTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.notificationItemCell(self, didTappedPhoto: indexPath.item)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
 
extension NotificationItemTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = dataSource?.photosList(self, associatedIndexPath: self.associatedIndexPath).count ?? 0
        return dataSource?.photosList(self, associatedIndexPath: self.associatedIndexPath).count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationItemImageCollectionViewCell.identifier, for: indexPath) as! NotificationItemImageCollectionViewCell
        
        let imagePath = dataSource?.photosList(self, associatedIndexPath: self.associatedIndexPath)[safe: indexPath.row]
        cell.mainImageView.setImage(withPath: imagePath, placeholderImage: UIImage(named: "ic_photo_placeholder"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }
    
}
