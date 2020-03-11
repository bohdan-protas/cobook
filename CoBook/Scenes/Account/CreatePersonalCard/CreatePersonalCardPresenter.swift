//
//  CreatePersonalCardPresenter.swift
//  CoBook
//
//  Created by protas on 3/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol CreatePersonalCardView: AlertDisplayableView, LoadDisplayableView {
    var tableView: UITableView! { get set }
}

class CreatePersonalCardPresenter: BasePresenter {
    weak var view: CreatePersonalCardView?
    var dataSource: CreatePersonalCardDataSource?

    func attachView(_ view: CreatePersonalCardView) {
        self.view = view
        self.dataSource = CreatePersonalCardDataSource(tableView: view.tableView)
    }

    func detachView() {
        view = nil
        dataSource = nil
    }

    func setup() {
        dataSource?.source = [

            PersonalCard.Section(items: [
                .title(text: "Діяльність"),
                .textField(type: .activityDescription),
                .textField(type: .activityRegion),
                .textField(type: .occupiedPosition),
                .textField(type: .workingEmailForCommunication),
                .textField(type: .workingPhoneNumber),
            ]),

            PersonalCard.Section(items: [
                .title(text: "Контактні дані"),
                .textField(type: .workingEmailForCommunication),
                .textField(type: .workingPhoneNumber)
            ])


        ]

        dataSource?.tableView.reloadData()
    }

}
