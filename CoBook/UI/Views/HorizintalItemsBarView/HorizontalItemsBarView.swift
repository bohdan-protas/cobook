//
//  HorizontalItemsBarView.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct BarItemViewModel {
    var index: Int
    var title: String?
}

protocol HorizontalItemsBarViewDelegate: class {
    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int)
}

class HorizontalItemsBarView: BaseFromNibView {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!

    var selectionIndicatorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 1
        view.backgroundColor = UIColor.Theme.green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var selectionIndicatorWidth: NSLayoutConstraint?
    var selectionIndicatorHeight: NSLayoutConstraint?
    var selectionIndicatorBottom: NSLayoutConstraint?
    var selectionIndicatorCenterX: NSLayoutConstraint?

    weak var delegate: HorizontalItemsBarViewDelegate?
    var dataSource: [BarItemViewModel] = []

    override func getNib() -> UINib {
        return HorizontalItemsBarView.nib
    }

    init(frame: CGRect, dataSource: [BarItemViewModel]) {
        super.init(frame: frame)
        self.dataSource = dataSource

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HorizontalBarItemCollectionViewCell.nib, forCellWithReuseIdentifier: HorizontalBarItemCollectionViewCell.identifier)
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)

        collectionViewFlowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewFlowLayout.estimatedItemSize = .init(width: 50, height: collectionView.frame.height)

        collectionView.addSubview(selectionIndicatorView)

        var width = dataSource.first?.title?.width(withConstrainedHeight: self.collectionView.frame.height, font: UIFont.SFProDisplay_Regular(size: 14)) ?? 0
        width += 20

        selectionIndicatorWidth = selectionIndicatorView.widthAnchor.constraint(equalToConstant:  width)
        selectionIndicatorHeight = selectionIndicatorView.heightAnchor.constraint(equalToConstant: 4)
        selectionIndicatorBottom = selectionIndicatorView.bottomAnchor.constraint(equalTo: collectionView.superview!.bottomAnchor)
        selectionIndicatorCenterX = selectionIndicatorView.leftAnchor.constraint(equalTo: collectionView.leftAnchor)

        selectionIndicatorWidth?.isActive = true
        selectionIndicatorHeight?.isActive = true
        selectionIndicatorBottom?.isActive = true
        selectionIndicatorCenterX?.isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refresh() {
        selectionIndicatorCenterX?.constant = 0

        var width = dataSource.first?.title?.width(withConstrainedHeight: self.collectionView.frame.height, font: UIFont.SFProDisplay_Regular(size: 14)) ?? 0
        width += 20

        selectionIndicatorWidth?.constant = width

        self.collectionView.layoutIfNeeded()
    }

}

// MARK: - UICollectionViewDataSource

extension HorizontalItemsBarView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalBarItemCollectionViewCell.identifier, for: indexPath) as! HorizontalBarItemCollectionViewCell

        let item = self.dataSource[safe: indexPath.item]
        cell.nameLabel.text = item?.title
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
        UIView.animate(withDuration: 0.15, animations: {
            self.collectionView.layoutIfNeeded()
        }, completion: { isFinished in
            self.delegate?.horizontalItemsBarView(self, didSelectedItemAt: indexPath.item)
        })
    }


}




