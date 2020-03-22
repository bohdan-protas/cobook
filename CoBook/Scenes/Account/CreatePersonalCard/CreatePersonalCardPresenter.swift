//
//  CreatePersonalCardPresenter.swift
//  CoBook
//
//  Created by protas on 3/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire

protocol CreatePersonalCardView: AlertDisplayableView, LoadDisplayableView, NavigableView {
    var tableView: UITableView! { get set }
    func showAutocompleteController(filter: GMSAutocompleteFilter, completion: ((GMSPlace) -> Void)?)
    func setSaveButtonEnabled(_ isEnabled: Bool)
    func setImage(image: UIImage?)
    func setupHeaderFooterViews()
    func addNewSocial(name: String?, link: String?, completion: ((_ name: String?, _ url: String?) -> Void)?)
}

class CreatePersonalCardPresenter: NSObject, BasePresenter {

    enum Defaults {
        static let imageCompressionQuality: CGFloat = 0.1
    }

    // MARK: Properties
    weak var view: CreatePersonalCardView?

    private var dataSource: CreatePersonalCardDataSource?
    private var interests:  [CreatePersonalCard.Interest] = []
    private var practices:  [CreatePersonalCard.Practice] = []
    private var socialList: [Social.ListItem] = []

    private var personalCardParameters = PersonalCardAPI.Request.CreationParameters() {
        didSet {
            view?.setSaveButtonEnabled(personalCardParameters.isRequiredDataFilled)
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
        fetchSetupData()
    }

    func createPerconalCard() {
        view?.startLoading()
        APIClient.default.createPersonalCard(parameters: self.personalCardParameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            switch result {
            case .success:
                strongSelf.view?.infoAlert(title: nil, message: "Успішно створено візитку", handler: { [weak self] (_) in
                    self?.view?.popController()
                })
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func userImagePicked(_ image: UIImage?) {
        let selectedUserImageData = image?.jpegData(compressionQuality: Defaults.imageCompressionQuality)
        self.uploadUserImage(data: selectedUserImageData)
    }


}

// MARK: - CreatePersonalCardPresenter
private extension CreatePersonalCardPresenter {

    func setupDataSource() {
        view?.setupHeaderFooterViews()
        invalidateDataSource()
        dataSource?.cellsDelegate = self
        dataSource?.tableView.reloadData()
    }

    func invalidateDataSource() {
        dataSource?.source = [

            CreatePersonalCard.Section(items: [
                .title(text: "Діяльність:"),
                .textField(type: .occupiedPosition),
                .actionTextField(type: .activityType(list: practices)),
                .actionTextField(type: .placeOfLiving),
                .actionTextField(type: .activityRegion),
                .textView(type: .activityDescription)
            ]),

            CreatePersonalCard.Section(items: [
                .title(text: "Контактні дані:"),
                .textField(type: .workingEmailForCommunication),
                .textField(type: .workingPhoneNumber),
                .title(text: "Соціальні мережі:"),
                .socialList(list: socialList)
            ]),

            CreatePersonalCard.Section(items: [
                .title(text: "Інтереси (для рекомендацій)"),
                .interests(list: interests)
            ])

        ]
    }

    func fetchSetupData() {
        let group = DispatchGroup()

        var practicesTypesListRequestError: Error?
        var interestsListRequestError: Error?

        view?.startLoading()

        // fetch practices
        group.enter()
        APIClient.default.practicesTypesListRequest { [weak self] (result) in
            guard let strongSelf = self else { return }

            switch result {
            case let .success(response):
                strongSelf.practices = (response ?? []).map { CreatePersonalCard.Practice(id: $0.id, title: $0.title) }
                group.leave()
            case let .failure(error):
                practicesTypesListRequestError = error
                group.leave()
            }
        }

        // fetch interests
        group.enter()
        APIClient.default.interestsListRequest { [weak self] (result) in
            guard let strongSelf = self else { return }

            switch result {
            case let .success(response):
                strongSelf.interests = (response ?? []).map { CreatePersonalCard.Interest(id: $0.id, title: $0.title) }
                group.leave()
            case let .failure(error):
                interestsListRequestError = error
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            if practicesTypesListRequestError != nil {
                strongSelf.view?.errorAlert(message: practicesTypesListRequestError?.localizedDescription)
                return
            }

            if interestsListRequestError != nil  {
                strongSelf.view?.errorAlert(message: interestsListRequestError?.localizedDescription)
            }

            strongSelf.setupDataSource()
        }
    }

    func uploadUserImage(data: Data?) {
        guard let imageData = data else {
            Log.error("Cannot find selected image data!")
            return
        }

        view?.startLoading()
        APIClient.default.upload(imageData: imageData) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            switch result {
            case let .success(response):
                strongSelf.personalCardParameters.avatarId = response?.id
                strongSelf.view?.setImage(image: UIImage(data: imageData))
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }

    }


}

// MARK: - InterestsSelectionTableViewCell Delegation
extension CreatePersonalCardPresenter: InterestsSelectionTableViewCellDelegate {

    func interestsSelectionTableViewCell(_ cell: InterestsSelectionTableViewCell, didSelectInterestAt index: Int) {
        interests[safe: index]?.isSelected = true
        invalidateDataSource()

        personalCardParameters.interestsIds = interests
            .filter { $0.isSelected }
            .compactMap { $0.id }
    }

    func interestsSelectionTableViewCell(_ cell: InterestsSelectionTableViewCell, didDeselectInterestAt index: Int) {
        interests[safe: index]?.isSelected = false
        invalidateDataSource()

        personalCardParameters.interestsIds = interests
            .filter { $0.isSelected }
            .compactMap { $0.id }
    }


}

// MARK: - TextViewTableViewCell Delegation
extension CreatePersonalCardPresenter: TextViewTableViewCellDelegate {

    func textViewTableViewCell(_ cell: TextViewTableViewCell, didUpdatedText text: String?, textTypeIdentifier identifier: String?) {
        guard let textType = CreatePersonalCard.TextType.init(rawValue: identifier ?? "") else {
            return
        }

        switch textType {
        case .occupiedPosition:
            personalCardParameters.position = text
        case .activityDescription:
            personalCardParameters.description = text
        case .workingPhoneNumber:
            personalCardParameters.contactTelephone = text
        case .workingEmailForCommunication:
            personalCardParameters.contactEmail = text
        }
    }


}

// MARK: - TextFieldTableViewCell Delegation
extension CreatePersonalCardPresenter: TextFieldTableViewCellDelegate {

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, textTypeIdentifier identifier: String?) {
        guard let textType = CreatePersonalCard.TextType.init(rawValue: identifier ?? "") else {
            return
        }

        switch textType {
        case .occupiedPosition:
            personalCardParameters.position = text
        case .activityDescription:
            personalCardParameters.description = text
        case .workingPhoneNumber:
            personalCardParameters.contactTelephone = text
        case .workingEmailForCommunication:
            personalCardParameters.contactEmail = text
        }
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?) {
        guard let action = CreatePersonalCard.ActionType.init(rawValue: identifier ?? "") else {
            return
        }

        switch action {
        case .activityType:
            let selectedPractice = cell.textView.text
            personalCardParameters.practiseTypeId = self.practices.first(where: { $0.title == selectedPractice })?.id
        case .placeOfLiving:
            let filter = GMSAutocompleteFilter()
            filter.type = .city
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedPlace) in
                cell.textView.text = fetchedPlace.name
                self?.personalCardParameters.cityPlaceId = fetchedPlace.placeID
            })
        case .activityRegion:
            let filter = GMSAutocompleteFilter()
            filter.type = .region
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedPlace) in
                cell.textView.text = fetchedPlace.name
                self?.personalCardParameters.regionPlaceId = fetchedPlace.placeID
             })
        }
    }


}

// MARK: - SocialsListTableViewCell delegation
extension CreatePersonalCardPresenter: SocialsListTableViewCellDelegate {

    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didSelectedSocialItem item: Social.ListItem) {
        switch item {
        case .view(let model):
            Log.debug("\(model.title) selected")
        case .add:
            view?.addNewSocial(name: nil, link: nil) { (name, strUrl) in
                guard let name = name, let url = URL.init(string: strUrl ?? "") else {
                    self.view?.errorAlert(message: "Перевірне вхідні дані")
                    return
                }

                let newItem = Social.ListItem.view(model: Social.Model(title: name, url: url))
                self.socialList.append(newItem)
                self.invalidateDataSource()

                cell.create(socialListItem: newItem)
            }
        }
    }

    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didLongPresseddOnItem value: Social.Model, at indexPath: IndexPath) {

        let actions: [UIAlertAction] = [

            .init(title: "Видалити", style: .destructive, handler: { (_) in
                cell.deleteAt(indexPath: indexPath)
                self.socialList.remove(at: indexPath.item)
                self.invalidateDataSource()
            }),

            .init(title: "Змінити", style: .default, handler: { (_) in
                self.view?.addNewSocial(name: value.title, link: value.url?.absoluteString) { (name, strUrl) in
                    guard let name = name, let url = URL.init(string: strUrl ?? ""), UIApplication.shared.canOpenURL(url) else {
                        self.view?.errorAlert(message: "Перевірне вхідні дані")
                        return
                    }

                    let newItem = Social.ListItem.view(model: Social.Model(title: name, url: url))
                    cell.updateAt(indexPath: indexPath, with: newItem)

                    self.socialList[safe: indexPath.item] = newItem
                    self.invalidateDataSource()
                }
            }),

            .init(title: "Відмінити", style: .cancel, handler: { (_) in
                Log.debug("Cancel")
            })

        ]

        view?.actionSheetAlert(title: value.title, message: nil, actions: actions)
    }


}
