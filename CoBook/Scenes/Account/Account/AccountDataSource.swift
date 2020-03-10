//
//  AccountDataManager.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class AccountDataSource: NSObject, UITableViewDataSource {

    var sections: [Account.Section] = []

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return sections[safe: section]?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataType =  sections[safe: indexPath.section]?.items[safe: indexPath.item] else {
            return UITableViewCell()
        }

        switch dataType {
        case .action(let type):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountItemTableViewCell.identifier, for: indexPath) as? AccountItemTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title
            cell.typeImageView.image = type.image
            return cell

        case .businessCard(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountBusinessCardTableViewCell.identifier, for: indexPath) as? AccountBusinessCardTableViewCell else {
                return UITableViewCell()
            }
            cell.fill(with: model)
            return UITableViewCell()
        }

    }
    


}
