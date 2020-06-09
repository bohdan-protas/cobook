//
//  FilterDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 6/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


struct FilterCellsConfigurator: CollectionCellConfiguratorType {

    var actionTitleConfigurator: CollectionCellConfigurator<ActionTitleModel, ActionTitleCollectionViewCell>
    var practiceFilterItemConfigurator: CollectionCellConfigurator<PracticeModel, TagItemCollectionViewCell>

    func reuseIdentifier(for item: Filter.Items, indexPath: IndexPath) -> String {
        switch item {
        case .title:
            return actionTitleConfigurator.reuseIdentifier
        case .practiceItem:
            return practiceFilterItemConfigurator.reuseIdentifier
        }
    }

    func configuredCell(for item: Filter.Items, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch item {
        case .title(let model):
            return actionTitleConfigurator.configuredCell(for: model, collectionView: collectionView, indexPath: indexPath)
        case .practiceItem(let model):
            return practiceFilterItemConfigurator.configuredCell(for: model, collectionView: collectionView, indexPath: indexPath)
        }
    }

    func registerCells(in collectionView: UICollectionView) {
        actionTitleConfigurator.registerCells(in: collectionView)
        practiceFilterItemConfigurator.registerCells(in: collectionView)
    }


}
