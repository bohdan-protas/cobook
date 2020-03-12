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
                .textField(type: .occupiedPosition, action: nil),
                .textField(type: .activityType, action: .listOfActivities),
                .textField(type: .placeOfLiving, action: .placeAutocomplete),
                .textField(type: .activityRegion, action: nil),
                .textView(type: .activityDescription)
            ]),

            PersonalCard.Section(items: [
                .title(text: "Контактні дані"),
                .textField(type: .workingEmailForCommunication, action: nil),
                .textField(type: .workingPhoneNumber, action: nil)
            ])

        ]

        dataSource?.cellsDelegate = self
        dataSource?.tableView.reloadData()
    }

}

// MARK: - CreatePersonalCardPresenter
extension CreatePersonalCardPresenter: TextViewTableViewCellDelegate, TextFieldTableViewCellDelegate {

    func didChangedText(_ cell: TextViewTableViewCell, updatedText text: String?, textTypeIdentifier identifier: String?) {
        print("text changed on:\(cell),  text: \(text ?? ""), type: \(identifier ?? "")")
    }

    func didChangedText(_ cell: TextFieldTableViewCell, updatedText text: String?, textTypeIdentifier identifier: String?) {
        print("text changed on:\(cell),  text: \(text ?? ""), type: \(identifier ?? "")")
    }

    func didOccuredAction(_ cell: TextFieldTableViewCell, actionIdentifier identifier: String?) {
        print("action occured on:\(cell),  id: \(identifier ?? "")")
    }

    
}
