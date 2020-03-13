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


    var interests: [PersonalCard.Interest] = [.init(title: "1"),
                                              .init(title: "2"),
                      .init(title: "3"),
                      .init(title: "4"),
                      .init(title: "5"),
                      .init(title: "6"),
                      .init(title: "7"),
                      .init(title: "8"),
                      .init(title: "9")
    ]

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
            ]),

            PersonalCard.Section(items: [
                .title(text: "Інтереси (для рекомендацій)"),
                .interests(list: interests)
            ])

        ]

        dataSource?.cellsDelegate = self
        dataSource?.tableView.reloadData()
    }

}

// MARK: - CreatePersonalCardPresenter
extension CreatePersonalCardPresenter: TextViewTableViewCellDelegate, TextFieldTableViewCellDelegate, InterestsSelectionTableViewCellDelegate {

    func interestsSelectionTableViewCell(_ cell: InterestsSelectionTableViewCell, didSelectInterestAt index: Int) {
        guard let indexPath = view?.tableView.indexPath(for: cell), let data = dataSource?.source[safe: indexPath.section]?.items[safe: indexPath.row] else {
            return
        }

        if case .interests(var list) = data {
            list[safe: index]?.isSelected = true
            dataSource?[indexPath] = .interests(list: list)
        }
    }

    func interestsSelectionTableViewCell(_ cell: InterestsSelectionTableViewCell, didDeselectInterestAt index: Int) {
        guard let indexPath = view?.tableView.indexPath(for: cell), let data = dataSource?.source[safe: indexPath.section]?.items[safe: indexPath.row] else {
            return
        }

        if case .interests(var list) = data {
            list[safe: index]?.isSelected = false
            dataSource?[indexPath] = .interests(list: list)
        }
    }

    func textViewTableViewCell(_ cell: TextViewTableViewCell, didUpdatedText text: String?, textTypeIdentifier identifier: String?) {
        print("text changed on:\(cell),  text: \(text ?? ""), type: \(identifier ?? "")")
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, textTypeIdentifier identifier: String?) {
        print("text changed on:\(cell),  text: \(text ?? ""), type: \(identifier ?? "")")
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?) {
         print("action occured on:\(cell),  id: \(identifier ?? "")")
    }


    
}
