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

    // MARK: Properties
    weak var view: CreatePersonalCardView?

    private var dataSource: CreatePersonalCardDataSource?

    private var interests: [PersonalCard.Interest] = []
    private var practices: [PersonalCard.Practice] = []

    // MARK: Public
    func attachView(_ view: CreatePersonalCardView) {
        self.view = view
        self.dataSource = CreatePersonalCardDataSource(tableView: view.tableView)
    }

    func detachView() {
        view = nil
        dataSource = nil
    }

    func setup() {

        var errors: [String] = []

        let group = DispatchGroup()
        view?.startLoading()

        group.enter()
        APIClient.default.practicesTypesListRequest { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case let .success(response):
                if response.status == .error {
                    errors.append(response.errorLocalizadMessage ?? "")
                    return
                }

                strongSelf.practices = (response.data ?? []).map { PersonalCard.Practice(id: $0.id, title: $0.title) }
                group.leave()
            case let .failure(error):
                errors.append(error.localizedDescription)
                group.leave()
            }
        }

        group.enter()
        APIClient.default.interestsListRequest { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case let .success(response):
                if response.status == .error {
                    errors.append(response.errorLocalizadMessage ?? "")
                    return
                }

                strongSelf.interests = (response.data ?? []).map { PersonalCard.Interest(id: $0.id, title: $0.title) }
                group.leave()
            case let .failure(error):
                errors.append(error.localizedDescription)
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            if !errors.isEmpty {
                errors.forEach {
                    self?.view?.errorAlert(message: $0)
                }
            }
            strongSelf.setupDataSource()
        }

    }

    func userImagePicked(_ image: UIImage?) {

    }



}

// MARK: - CreatePersonalCardPresenter
private extension CreatePersonalCardPresenter {

    func setupDataSource() {
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
