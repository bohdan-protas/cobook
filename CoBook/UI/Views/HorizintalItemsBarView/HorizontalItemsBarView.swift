//
//  HorizontalItemsBarView.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct BarItemViewModel {
    var title: String?
    var isSelected: Bool?
}

protocol HorizontalItemsBarViewDataSource: class {
    func numberOfItems(in view: HorizontalItemsBarView) -> Int
    func horizontalItemsBarView(_ view: HorizontalItemsBarView, titleForItemAt index: Int) -> BarItemViewModel?
}

protocol HorizontalItemsBarViewDelegate: class {
    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int)
}

class HorizontalItemsBarView: BaseFromNibView {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!

    var selectionIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Theme.green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var selectionIndicatorWidth: NSLayoutConstraint?
    var selectionIndicatorHeight: NSLayoutConstraint?
    var selectionIndicatorBottom: NSLayoutConstraint?
    var selectionIndicatorCenterX: NSLayoutConstraint?

    weak var delegate: HorizontalItemsBarViewDelegate?
    var dataSource: HorizontalItemsBarViewDataSource?

    override func getNib() -> UINib {
        return HorizontalItemsBarView.nib
    }

    override func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HorizontalBarItemCollectionViewCell.nib, forCellWithReuseIdentifier: HorizontalBarItemCollectionViewCell.identifier)
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)

        collectionViewFlowLayout.estimatedItemSize = .init(width: 100, height: collectionView.frame.height)
        collectionViewFlowLayout.itemSize = UICollectionViewFlowLayout.automaticSize


        collectionView.addSubview(selectionIndicatorView)

        selectionIndicatorWidth = selectionIndicatorView.widthAnchor.constraint(equalToConstant: 100)
        selectionIndicatorHeight = selectionIndicatorView.heightAnchor.constraint(equalToConstant: 2)
        selectionIndicatorBottom = selectionIndicatorView.bottomAnchor.constraint(equalTo: collectionView.superview!.bottomAnchor)
        selectionIndicatorCenterX = selectionIndicatorView.leftAnchor.constraint(equalTo: collectionView.leftAnchor)

        selectionIndicatorWidth?.isActive = true
        selectionIndicatorHeight?.isActive = true
        selectionIndicatorBottom?.isActive = true
        selectionIndicatorCenterX?.isActive = true
    }
    

}

// MARK: - UICollectionViewDataSource

extension HorizontalItemsBarView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: self) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalBarItemCollectionViewCell.identifier, for: indexPath) as! HorizontalBarItemCollectionViewCell

        let item = self.dataSource?.horizontalItemsBarView(self, titleForItemAt: indexPath.item)
        cell.nameLabel.text = item?.title
        cell.isSelected = item?.isSelected ?? false
        cell.maxWidth = self.collectionView.frame.width / 4
        return cell
    }


}

// MARK: - UICollectionViewDelegate

extension HorizontalItemsBarView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        let cellCenter: CGPoint = collectionView.convert(cell.center, to: collectionView)
        selectionIndicatorCenterX?.constant = (cellCenter.x - (cell.frame.width/2))
        selectionIndicatorWidth?.constant = cell.frame.width

        collectionView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.2, animations: {
            self.collectionView.layoutIfNeeded()
        }, completion: { isFinished in
            self.delegate?.horizontalItemsBarView(self, didSelectedItemAt: indexPath.item)
        })
    }


}
