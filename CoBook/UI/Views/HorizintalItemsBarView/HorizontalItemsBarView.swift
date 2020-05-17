//
//  HorizontalItemsBarView.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct BarItem: Equatable {
    var index: Int
    var title: String?
    static func == (lhs: BarItem, rhs: BarItem) -> Bool {
        return lhs.index == rhs.index
    }
}

private enum Layout {
    static let padding: CGFloat = 20
}

// MARK: - HorizontalItemsBarView

protocol HorizontalItemsBarViewDelegate: class {
    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int)
    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didLongTappedItemAt index: Int)
}

extension HorizontalItemsBarViewDelegate {
    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didLongTappedItemAt index: Int) {}
}

class HorizontalItemsBarView: BaseFromNibView {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!

    private var selectionIndicatorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 1
        view.backgroundColor = UIColor.Theme.green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var selectionIndicatorWidth: NSLayoutConstraint?
    private var selectionIndicatorHeight: NSLayoutConstraint?
    private var selectionIndicatorBottom: NSLayoutConstraint?
    private var selectionIndicatorCenterX: NSLayoutConstraint?

    private var isNeedToMigrate: Bool = false
    private var migrationIndex: Int = 0

    var dataSource: [BarItem] = []
    var currentItem: BarItem?
    weak var delegate: HorizontalItemsBarViewDelegate?

    // MARK: - Lifecycle

    override func getNib() -> UINib {
        return HorizontalItemsBarView.nib
    }

    init(frame: CGRect, dataSource: [BarItem]) {
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
        if width > 0 {
            width += Layout.padding
        }
        selectionIndicatorWidth = selectionIndicatorView.widthAnchor.constraint(equalToConstant:  width)
        selectionIndicatorHeight = selectionIndicatorView.heightAnchor.constraint(equalToConstant: 4)
        selectionIndicatorBottom = selectionIndicatorView.bottomAnchor.constraint(equalTo: collectionView.superview!.bottomAnchor)
        selectionIndicatorCenterX = selectionIndicatorView.leftAnchor.constraint(equalTo: collectionView.leftAnchor)
        currentItem = dataSource.first

        selectionIndicatorWidth?.isActive = true
        selectionIndicatorHeight?.isActive = true
        selectionIndicatorBottom?.isActive = true
        selectionIndicatorCenterX?.isActive = true

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGestureRecognizer.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {
        if gesture.state != .began {
            return
        }

        let location = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: location) {
            delegate?.horizontalItemsBarView(self, didLongTappedItemAt: indexPath.item)
        }
    }

    // MARK: - Public

    func update(at itemIndex: Int, with item: BarItem) {
        collectionView.performBatchUpdates({
            self.dataSource[safe: itemIndex] = item
            let indexPath = IndexPath(item: itemIndex, section: 0)
            collectionView.reloadItems(at: [indexPath])

            // Check if updated current selected item
            if let currentItem = currentItem, let currentItemIndex = dataSource.firstIndex(of: currentItem), currentItemIndex == itemIndex {
                var width = dataSource[safe: itemIndex]?.title?.width(withConstrainedHeight: self.collectionView.frame.height, font: UIFont.SFProDisplay_Regular(size: 14)) ?? 0
                if width > 0 {
                    width += Layout.padding
                }
                selectionIndicatorWidth?.constant = width
            }
        }, completion: { finished in

        })
    }

    func append(barItem: BarItem) {
        collectionView.performBatchUpdates({
            dataSource.append(barItem)
            let indexPath = IndexPath(item: dataSource.count-1, section: 0)
            collectionView.insertItems(at: [indexPath])
        }, completion: { finished in
            self.collectionView.scrollToItem(at: IndexPath(item: self.dataSource.count-1, section: 0), at: .right, animated: true)
        })
    }

    func delete(at itemIndex: Int) {
        collectionView.performBatchUpdates({
            // Check if  deleted current selected item
            if let currentItem = currentItem, let currentItemIndex = dataSource.firstIndex(of: currentItem), currentItemIndex == itemIndex {
                isNeedToMigrate = true
                migrationIndex = currentItemIndex - 1
            }
            dataSource.remove(at: itemIndex)
            collectionView.deleteItems(at: [IndexPath(item: itemIndex, section: 0)])
        }, completion: { finished in
            if self.isNeedToMigrate {
                self.isNeedToMigrate = false
                self.setSelectedAt(index: self.migrationIndex) { [unowned self] in
                    self.collectionView.scrollToItem(at: IndexPath(item: self.migrationIndex, section: 0), at: .right, animated: true)
                    self.delegate?.horizontalItemsBarView(self, didSelectedItemAt: self.migrationIndex)
                }
            } else {
                self.setSelectedAt(index: itemIndex, animated: false, completion: {
                    self.collectionView.reloadData()
                })
            }
        })
    }

    func refresh() {
        selectionIndicatorCenterX?.constant = 0

        var width = dataSource.first?.title?.width(withConstrainedHeight: self.collectionView.frame.height, font: UIFont.SFProDisplay_Regular(size: 14)) ?? 0
        if width > 0 {
            width += Layout.padding
        }

        selectionIndicatorWidth?.constant = width
        self.collectionView.layoutIfNeeded()
        self.collectionView.reloadData()
    }

    // MARK: - Privates

    private func setSelectedAt(index: Int, animated: Bool = true,  completion: (() -> Void)? = nil) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) else {
            return
        }

        currentItem = dataSource[safe: index]
        let cellCenter: CGPoint = collectionView.convert(cell.center, to: collectionView)
        selectionIndicatorCenterX?.constant = (cellCenter.x - (cell.frame.width/2))
        selectionIndicatorWidth?.constant = cell.frame.width

        self.collectionView.layer.removeAllAnimations()
        UIView.animate(withDuration: animated ? 0.15 : 0, animations: {
            self.collectionView.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
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

// MARK: - UICollectionViewDelegateFlowLayout

extension HorizontalItemsBarView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = dataSource[indexPath.item].title?.width(withConstrainedHeight: collectionView.frame.height, font: UIFont.SFProDisplay_Regular(size: 14)) ?? 0
        width += Layout.padding
        return CGSize(width: width, height: collectionView.frame.height)
    }

}

// MARK: - UICollectionViewDelegate

extension HorizontalItemsBarView: UICollectionViewDelegate {

//    @available(iOS 13.0, *)
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action in
//
//            let edit = UIAction(title: "Змінити", image: UIImage(systemName: "arrow.clockwise"), identifier: nil, handler: { action in
//                //self.delegate?.didUpdatePhoto(self, at: indexPath)
//            })
//
//            let delete = UIAction(title: "Видалити", image: UIImage(systemName: "trash.fill"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: { action in
//                //self.delegate?.didDeletePhoto(self, at: indexPath)
//            })
//
//            return UIMenu(title: "Редагування списку", children: [edit, delete])
//        }
//        return configuration
//    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setSelectedAt(index: indexPath.item) { [unowned self] in
            self.delegate?.horizontalItemsBarView(self, didSelectedItemAt: indexPath.item)
        }
    }


}




