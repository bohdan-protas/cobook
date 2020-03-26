//
//  AccountDataManager.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import Kingfisher

class AccountDataSource: NSObject, UITableViewDataSource {

    //MARK: Properties
    var source: [Account.Section] = []
    unowned var tableView: UITableView
    
    // MARK: Lifecycle
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()

        tableView.dataSource = self
        tableView.register(CardPreviewTableViewCell.nib, forCellReuseIdentifier: CardPreviewTableViewCell.identifier)
        tableView.register(AccountItemTableViewCell.nib, forCellReuseIdentifier: AccountItemTableViewCell.identifier)
        tableView.register(SectionTitleTableViewCell.nib, forCellReuseIdentifier: SectionTitleTableViewCell.identifier)
        tableView.register(SectionHeaderTableViewCell.nib, forCellReuseIdentifier: SectionHeaderTableViewCell.identifier)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return source.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return source[safe: section]?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataType = source[safe: indexPath.section]?.items[safe: indexPath.item] else {
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

        case .businessCardPreview(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CardPreviewTableViewCell.identifier, for: indexPath) as? CardPreviewTableViewCell else {
                return UITableViewCell()
            }

            cell.proffesionLabel.text = model.profession
            cell.telephoneNumberLabel.text = model.telephone
            cell.companyNameLabel.text = model.name

            cell.titleImageView.kf.setImage(with: URL.init(string: model.image ?? ""), options: [.transition(.fade(0.3)),
                                                                                                 .processor(RoundCornerImageProcessor(cornerRadius: 16))])
            return cell

        case .personalCardPreview(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CardPreviewTableViewCell.identifier, for: indexPath) as? CardPreviewTableViewCell else {
                return UITableViewCell()
            }

            cell.proffesionLabel.text = model.profession
            cell.telephoneNumberLabel.text = model.telephone
            cell.companyNameLabel.text = model.name
            cell.titleImageView.kf.setImage(with: URL.init(string: model.image ?? ""), options: [.transition(.fade(0.3)),
                                                                                                 .processor(RoundCornerImageProcessor(cornerRadius: 16))])
            return cell

        case .title(let text):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionTitleTableViewCell.identifier, for: indexPath) as? SectionTitleTableViewCell else {
                return UITableViewCell()
            }

            cell.titleLabel.text = text
            return cell

        case .sectionHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionHeaderTableViewCell.identifier, for: indexPath) as! SectionHeaderTableViewCell
            return cell
        }

    }
    


}
