//
//  CreatePersonalCardPresenter.swift
//  CoBook
//
//  Created by protas on 3/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces

protocol CreatePersonalCardView: AlertDisplayableView, LoadDisplayableView {
    var tableView: UITableView! { get set }
    func showAutocompleteController(completion: ((GMSPlace) -> Void)?)
    func setSaveButtonEnabled(_ isEnabled: Bool)
    func popController()
}

class CreatePersonalCardPresenter: NSObject, BasePresenter {

    // MARK: Properties
    weak var view: CreatePersonalCardView?

    private var dataSource: CreatePersonalCardDataSource?
    private var interests: [PersonalCard.Interest] = []
    private var practices: [PersonalCard.Practice] = []

    private var createPersonalCardParameters = PersonalCardAPI.Request.CreationParameters() {
        didSet {
            print("changed personal card parameter")
            view?.setSaveButtonEnabled(createPersonalCardParameters.isRequiredDataIsFilled)
        }
    }

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

        // fetch practices
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

        // fetch interests
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

    func createPerconalCard() {
        view?.startLoading()
        APIClient.default.createPersonalCard(parameters: self.createPersonalCardParameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            switch result {
            case let .success(response):
                if response.status == .error {
                    strongSelf.view?.errorAlert(message: response.errorLocalizadMessage ?? "")
                }
                strongSelf.view?.infoAlert(title: nil, message: "Успішно створено візитку", handler: { [weak self] (_) in
                    self?.view?.popController()
                })
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
                debugPrint(error.localizedDescription)
            }
        }
    }



}

// MARK: - CreatePersonalCardPresenter
private extension CreatePersonalCardPresenter {

    func setupDataSource() {

        dataSource?.source = [
            PersonalCard.Section(items: [
                .title(text: "Діяльність"),
                .textField(type: .occupiedPosition),
                .actionTextField(type: .activityType(list: practices)),
                .actionTextField(type: .placeOfLiving),
                .actionTextField(type: .activityRegion),
                .textView(type: .activityDescription)
            ]),

            PersonalCard.Section(items: [
                .title(text: "Контактні дані"),
                .textField(type: .workingEmailForCommunication),
                .textField(type: .workingPhoneNumber)
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

// MARK: - InterestsSelectionTableViewCell Delegation
extension CreatePersonalCardPresenter: InterestsSelectionTableViewCellDelegate {

    func interestsSelectionTableViewCell(_ cell: InterestsSelectionTableViewCell, didSelectInterestAt index: Int) {
         guard let indexPath = view?.tableView.indexPath(for: cell), let data = dataSource?.source[safe: indexPath.section]?.items[safe: indexPath.row] else {
             return
         }

         if case .interests(var list) = data {
            list[safe: index]?.isSelected = true
            createPersonalCardParameters.interestsIds = list
                .filter { $0.isSelected }
                .compactMap { $0.id }
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


}

// MARK: - TextViewTableViewCell Delegation
extension CreatePersonalCardPresenter: TextViewTableViewCellDelegate {

    func textViewTableViewCell(_ cell: TextViewTableViewCell, didUpdatedText text: String?, textTypeIdentifier identifier: String?) {
        guard let textType = PersonalCard.TextType.init(rawValue: identifier ?? "") else {
            return
        }

        switch textType {
        case .occupiedPosition:
            createPersonalCardParameters.position = text
        case .activityDescription:
            createPersonalCardParameters.description = text
        case .workingPhoneNumber:
            createPersonalCardParameters.contactTelephone = text
        case .workingEmailForCommunication:
            createPersonalCardParameters.contactEmail = text
        }
    }


}

// MARK: - TextFieldTableViewCell Delegation
extension CreatePersonalCardPresenter: TextFieldTableViewCellDelegate {

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, textTypeIdentifier identifier: String?) {
        guard let textType = PersonalCard.TextType.init(rawValue: identifier ?? "") else {
            return
        }

        switch textType {
        case .occupiedPosition:
            createPersonalCardParameters.position = text
        case .activityDescription:
            createPersonalCardParameters.description = text
        case .workingPhoneNumber:
            createPersonalCardParameters.contactTelephone = text
        case .workingEmailForCommunication:
            createPersonalCardParameters.contactEmail = text
        }
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?) {
        guard let action = PersonalCard.ActionType.init(rawValue: identifier ?? "") else {
            return
        }

        switch action {
        case .activityType:
            let selectedPractice = cell.textView.text
            createPersonalCardParameters.practiseTypeId = self.practices.first(where: { $0.title == selectedPractice })?.id
        case .placeOfLiving:
            view?.showAutocompleteController(completion: { [weak self] (fetchedPlace) in
                cell.textView.text = fetchedPlace.name
                self?.createPersonalCardParameters.cityPlaceId = fetchedPlace.placeID
            })
        case .activityRegion:
            view?.showAutocompleteController(completion: { [weak self] (fetchedPlace) in
                cell.textView.text = fetchedPlace.name
                self?.createPersonalCardParameters.regionPlaceId = fetchedPlace.placeID
             })
        }
    }


}
