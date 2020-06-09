//
//  CollectionDataSource.swift
//  CoBook
//
//  Created by protas on 6/9/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


class CollectionDataSource<Configurator: CollectionCellConfiguratorType>: NSObject, UICollectionViewDataSource {

    var sections: [Section<Configurator.Item>] = []
    var configurator: Configurator?

    init(sections: [Section<Configurator.Item>] = [], configurator: Configurator? = nil) {
        self.sections = sections
        self.configurator = configurator
        super.init()
    }

    func connect(to collectionView: UICollectionView) {
        collectionView.dataSource = self
        configurator?.registerCells(in: collectionView)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[safe: section]?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = sections[safe: indexPath.section]?.items[safe: indexPath.item] else {
            return UICollectionViewCell()
        }
        let configuredCell = configurator?.configuredCell(for: item, collectionView: collectionView, indexPath: indexPath)
        return configuredCell ?? UICollectionViewCell()
    }


}
