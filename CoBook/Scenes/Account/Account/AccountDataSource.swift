//
//  AccountDataManager.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class AccountDataSource: NSObject, UITableViewDataSource {

    //MARK: Properties
    var source: [Account.Section] = []
    unowned var tableView: UITableView
    
    // MARK: Lifecycle
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()

        tableView.dataSource = self
        tableView.register(AccountHeaderTableViewCell.nib, forCellReuseIdentifier: AccountHeaderTableViewCell.identifier)
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

        case .userInfoHeader(let avatarUrl, let firstName, let lastName, let telephone, let email):
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountHeaderTableViewCell.identifier, for: indexPath) as! AccountHeaderTableViewCell
            cell.avatarTextPlaceholderImageView.setImage(withPath: avatarUrl, placeholderText: "\(firstName?.first?.uppercased() ?? "") \(lastName?.first?.uppercased() ?? "")")
            cell.userNameLabel.text = "\(firstName ?? "") \(lastName ?? "")"
            cell.emailLabel.text = email
            cell.telephoneNumberLabel.text = telephone
            return cell

        case .action(let type):
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountItemTableViewCell.identifier, for: indexPath) as! AccountItemTableViewCell
            cell.titleLabel.text = type.title
            cell.typeImageView.image = type.image
            return cell

        case .businessCardPreview(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: CardPreviewTableViewCell.identifier, for: indexPath) as! CardPreviewTableViewCell
            cell.proffesionLabel.text = model.profession
            cell.telephoneNumberLabel.text = model.telephone
            cell.companyNameLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"
            cell.titleImageView.setImage(withPath: model.image, placeholderText: "\(model.firstName?.first?.uppercased() ?? "") \(model.lastName?.first?.uppercased() ?? "")")
            return cell

        case .personalCardPreview(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: CardPreviewTableViewCell.identifier, for: indexPath) as! CardPreviewTableViewCell
            cell.proffesionLabel.text = model.profession
            cell.telephoneNumberLabel.text = model.telephone
            cell.companyNameLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"
            cell.titleImageView.setImage(withPath: model.image, placeholderText: "\(model.firstName?.first?.uppercased() ?? "") \(model.lastName?.first?.uppercased() ?? "")")
            return cell

        case .title(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionTitleTableViewCell.identifier, for: indexPath) as! SectionTitleTableViewCell
            cell.titleLabel.text = text
            return cell

        case .sectionHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionHeaderTableViewCell.identifier, for: indexPath) as! SectionHeaderTableViewCell
            return cell
        }

    }
    


}
