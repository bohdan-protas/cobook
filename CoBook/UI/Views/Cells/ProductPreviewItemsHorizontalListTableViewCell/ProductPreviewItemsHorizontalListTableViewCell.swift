//
//  ProductPreviewItemsHorizontalListTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/29/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


class ProductPreviewItemsHorizontalListTableViewCell: UITableViewCell {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    var dataSource: [ProductPreviewItemModel] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductPreviewItemCollectionViewCell.nib, forCellWithReuseIdentifier: ProductPreviewItemCollectionViewCell.identifier)
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)

    }

    
}

extension ProductPreviewItemsHorizontalListTableViewCell: UICollectionViewDelegate {

}

extension ProductPreviewItemsHorizontalListTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductPreviewItemCollectionViewCell.identifier, for: indexPath) as! ProductPreviewItemCollectionViewCell
        let model = dataSource[indexPath.item]

        cell.titleImageView.setImage(withPath: model.image)
        cell.productNameLabel.text = model.name
        cell.productPriceLabel.text = model.price

        return cell
    }


}
