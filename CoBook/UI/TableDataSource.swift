//
//  DataSource.swift
//  CoBook
//
//  Created by protas on 4/1/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class TableDataSource<Configurator: CellConfiguratorType>: NSObject, UITableViewDataSource {

    var sections: [Section<Configurator.Item>] = []
    let configurator: Configurator?

    unowned var tableView: UITableView

    init(tableView: UITableView, sections: [Section<Configurator.Item>] = [], configurator: Configurator?) {
        self.tableView = tableView
        self.sections = sections
        self.configurator = configurator
        super.init()

        tableView.dataSource = self
        configurator?.registerCells(in: tableView)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safe: section]?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = sections[safe: indexPath.section]?.items[safe: indexPath.item] else {
            return UITableViewCell()
        }
        let configuredCell = configurator?.configuredCell(for: item, tableView: tableView, indexPath: indexPath)
        return configuredCell ?? UITableViewCell()
    }


}

class DataSource<Configurator: CellConfiguratorType>: NSObject, UITableViewDataSource {

    var sections: [Section<Configurator.Item>] = []
    var configurator: Configurator?

    init(sections: [Section<Configurator.Item>] = [], configurator: Configurator? = nil) {
        self.sections = sections
        self.configurator = configurator
        super.init()
    }

    func connect(to tableView: UITableView) {
        tableView.dataSource = self
        configurator?.registerCells(in: tableView)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safe: section]?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = sections[safe: indexPath.section]?.items[safe: indexPath.item] else {
            return UITableViewCell()
        }
        let configuredCell = configurator?.configuredCell(for: item, tableView: tableView, indexPath: indexPath)
        return configuredCell ?? UITableViewCell()
    }


}

extension DataSource {
    subscript(cardsOverviewIndex: CardsOverview.SectionAccessoryIndex) -> Section<Configurator.Item> {
        get {
            return sections[cardsOverviewIndex.rawValue]
        }

        set {
            sections[cardsOverviewIndex.rawValue] = newValue
        }
    }
}

extension DataSource {
    subscript(businessCardDetailsIndex: BusinessCardDetails.SectionAccessoryIndex) -> Section<Configurator.Item> {
        get {
            return sections[businessCardDetailsIndex.rawValue]
        }

        set {
            sections[businessCardDetailsIndex.rawValue] = newValue
        }
    }
}

extension DataSource {
    subscript(createServiceIndex: Service.CreationSectionAccessoryIndex) -> Section<Configurator.Item> {
         get {
             return sections[createServiceIndex.rawValue]
         }

         set {
             sections[createServiceIndex.rawValue] = newValue
         }
     }
}
