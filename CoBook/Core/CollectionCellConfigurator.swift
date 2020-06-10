//
//  CollectionCellConfigurator.swift
//  CoBook
//
//  Created by protas on 6/9/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


protocol CollectionCellConfiguratorType {
    associatedtype Item
    associatedtype Cell: UICollectionViewCell

    func reuseIdentifier(for item: Item, indexPath: IndexPath) -> String
    func configuredCell(for item: Item, collectionView: UICollectionView, indexPath: IndexPath) -> Cell
    func registerCells(in collectionView: UICollectionView)
}

struct CollectionCellConfigurator<Item, Cell: UICollectionViewCell>: CollectionCellConfiguratorType {
    typealias Configurator = (Cell, Item, UICollectionView, IndexPath) -> Cell

    let configurator: Configurator
    let reuseIdentifier = Cell.identifier

    func reuseIdentifier(for item: Item, indexPath: IndexPath) -> String {
        return reuseIdentifier
    }

    func configure(cell: Cell, item: Item, collectionView: UICollectionView, indexPath: IndexPath) -> Cell {
        return configurator(cell, item, collectionView, indexPath)
    }

    func registerCells(in collectionView: UICollectionView) {
        collectionView.register(Cell.nib, forCellWithReuseIdentifier: Cell.identifier)
    }

    func configuredCell(for item: Item, collectionView: UICollectionView, indexPath: IndexPath) -> Cell {
        let reuseIdentifier = self.reuseIdentifier(for: item, indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Cell
        return self.configure(cell: cell, item: item, collectionView: collectionView, indexPath: indexPath)
    }
}
