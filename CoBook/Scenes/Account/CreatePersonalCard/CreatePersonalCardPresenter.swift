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
    func setImage(image: URL?)
    func setupHeaderFooterViews()
    func addNewSocial(name: String?, link: String?, completion: ((_ name: String?, _ url: String?) -> Void)?)
}

protocol CreatePersonalCardPresenterDelegate: class {
    func createPersonalCardPresenterDidUpdatedPersonalCard(_ presenter: CreatePersonalCardPresenter)
}

class CreatePersonalCardPresenter: NSObject, BasePresenter {

    enum Defaults {
        static let imageCompressionQuality: CGFloat = 0.1
    }

    // MARK: Properties
    private weak var view: CreatePersonalCardView?
    private var viewDataSource: CreatePersonalCardDataSource?

    private var personalCardParameters: CardAPIModel.PersonalCardParameters {
        didSet {
            let isRequiredDataFilled: Bool =
                !(personalCardParameters.avatarId ?? "").isEmpty &&
                !(personalCardParameters.city.placeId ?? "").isEmpty &&
                !(personalCardParameters.region.placeId ?? "").isEmpty &&
                !(personalCardParameters.position ?? "").isEmpty &&
                !(personalCardParameters.description ?? "").isEmpty &&
                !(personalCardParameters.practiseType.id == nil) &&
                !(personalCardParameters.interests).isEmpty &&
                !(personalCardParameters.contactTelephone ?? "").isEmpty &&
                !(personalCardParameters.contactEmail ?? "").isEmpty
            
            view?.setSaveButtonEnabled(isRequiredDataFilled)
            syncDataSource()
        }
    }

    weak var delegate: CreatePersonalCardPresenterDelegate?
    
    // Lifecycle
    init(parameters: CardAPIModel.PersonalCardParameters? = nil) {
        self.personalCardParameters = parameters ?? CardAPIModel.PersonalCardParameters()
    }

    // MARK: Public
    func attachView(_ view: CreatePersonalCardView) {
        self.view = view
        self.viewDataSource = CreatePersonalCardDataSource(tableView: view.tableView)
    }

    func detachView() {
        view = nil
        viewDataSource = nil
    }

    func onViewDidLoad() {
        fetchDataSource()
    }

    func createPerconalCard() {
        view?.startLoading()
        APIClient.default.createPersonalCard(parameters: self.personalCardParameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            switch result {
            case .success:
                strongSelf.view?.infoAlert(title: nil, message: "Успішно створено візитку", handler: { (_) in
                    strongSelf.delegate?.createPersonalCardPresenterDidUpdatedPersonalCard(strongSelf)
                    strongSelf.view?.popController()
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
        viewDataSource?.cellsDelegate = self

        syncDataSource()
        viewDataSource?.tableView.reloadData()
    }

    func syncDataSource() {

        viewDataSource?.source = [
            CreatePersonalCard.Section(items: [
                .title(text: "Діяльність:"),
                .textField(text: personalCardParameters.position, type: .occupiedPosition),
                .actionTextField(text: personalCardParameters.practiseType.title, type: .activityType(list: personalCardParameters.practices)),
                .actionTextField(text: personalCardParameters.city.name, type: .placeOfLiving),
                .actionTextField(text: personalCardParameters.region.name, type: .activityRegion),
                .textView(text: personalCardParameters.description, type: .activityDescription)
            ]),
            CreatePersonalCard.Section(items: [
                .title(text: "Контактні дані:"),
                .textField(text: personalCardParameters.contactEmail, type: .workingEmailForCommunication),
                .textField(text: personalCardParameters.contactTelephone, type: .workingPhoneNumber),
                .title(text: "Соціальні мережі:"),
                .socialList(list: personalCardParameters.socialList)
            ]),
            CreatePersonalCard.Section(items: [
                .title(text: "Інтереси (для рекомендацій)"),
                .interests(list: personalCardParameters.interests)
            ])
        ]
    }

    func fetchDataSource() {
        let group = DispatchGroup()

        var practicesTypesListRequestError: Error?
        var interestsListRequestError: Error?

        view?.startLoading()
        view?.setImage(image: URL.init(string: personalCardParameters.avatarUrl ?? ""))

        // fetch practices
        group.enter()
        APIClient.default.practicesTypesListRequest { [weak self] (result) in
            guard let strongSelf = self else { return }

            switch result {
            case let .success(response):
                strongSelf.personalCardParameters.practices = (response ?? []).map { CreatePersonalCard.Practice(id: $0.id, title: $0.title) }
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
                let currentSelectedInterests = strongSelf.personalCardParameters.interests
                let fetchedInterests: [CreatePersonalCard.Interest] = (response ?? []).compactMap { fetched in
                    let isSelected = currentSelectedInterests.contains(where: { (selected) -> Bool in
                        return selected.id == fetched.id
                    })
                    return CreatePersonalCard.Interest(id: fetched.id, title: fetched.title, isSelected: isSelected)
                }

                strongSelf.personalCardParameters.interests = fetchedInterests
                group.leave()
            case let .failure(error):
                interestsListRequestError = error
                group.leave()
            }
        }

        // setup data source
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
        personalCardParameters.interests[safe: index]?.isSelected = true
    }

    func interestsSelectionTableViewCell(_ cell: InterestsSelectionTableViewCell, didDeselectInterestAt index: Int) {
        personalCardParameters.interests[safe: index]?.isSelected = false
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
            let selectedPracticeName = cell.textView.text
            let selectedPracticeId = personalCardParameters.practices.first(where: { $0.title == selectedPracticeName })?.id
            personalCardParameters.practiseType = CardAPIModel.PracticeType(id: selectedPracticeId,
                                                                            title: selectedPracticeName)
        case .placeOfLiving:
            let filter = GMSAutocompleteFilter()
            filter.type = .city
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedCity) in
                if let cityId = fetchedCity.placeID {
                    cell.textView.text = fetchedCity.name
                    self?.personalCardParameters.city = CardAPIModel.Place(placeId: cityId, name: fetchedCity.name)
                } else {
                    self?.view?.errorAlert(message: "Selected city data missing!")
                    Log.error("City data missing!")
                }

            })

        case .activityRegion:
            let filter = GMSAutocompleteFilter()
            filter.type = .region
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedRegion) in
                if let regionId = fetchedRegion.placeID {
                    Log.debug("Region id: \(regionId)")
                    cell.textView.text = fetchedRegion.name
                    self?.personalCardParameters.region = CardAPIModel.Place(placeId: regionId, name: fetchedRegion.name)
                } else {
                    self?.view?.errorAlert(message: "Selected region data missing!")
                    Log.error("Region data missing")
                }
            })

        }
    }


}

// MARK: - SocialsListTableViewCell delegation
extension CreatePersonalCardPresenter: SocialsListTableViewCellDelegate {

    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didSelectedSocialItem item: Social.ListItem) {
        switch item {
        case .add:
            view?.addNewSocial(name: nil, link: nil) { (name, strUrl) in
                guard let url = URL.init(string: strUrl ?? ""), UIApplication.shared.canOpenURL(url) else {
                    self.view?.errorAlert(message: "Посилання має хибний формат")
                    return
                }

                let newItem = Social.ListItem.view(model: Social.Model(title: name, url: url))
                cell.create(socialListItem: newItem)

                self.personalCardParameters.socialList.append(newItem)
                self.syncDataSource()
            }
        default:
            break
        }
    }

    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didLongPresseddOnItem value: Social.Model, at indexPath: IndexPath) {

        let actions: [UIAlertAction] = [

            .init(title: "Видалити", style: .destructive, handler: { (_) in
                cell.deleteAt(indexPath: indexPath)
                self.personalCardParameters.socialList.remove(at: indexPath.item)
            }),

            .init(title: "Змінити", style: .default, handler: { (_) in
                self.view?.addNewSocial(name: value.title, link: value.url?.absoluteString) { (name, strUrl) in
                    guard let name = name, let url = URL.init(string: strUrl ?? ""), UIApplication.shared.canOpenURL(url) else {
                        self.view?.errorAlert(message: "Посилання має хибний формат")
                        return
                    }

                    let newItem = Social.ListItem.view(model: Social.Model(title: name, url: url))
                    cell.updateAt(indexPath: indexPath, with: newItem)
                    self.personalCardParameters.socialList[safe: indexPath.item] = newItem
                }
            }),

            .init(title: "Відмінити", style: .cancel, handler: { (_) in
                Log.debug("Cancel")
            })

        ]

        view?.actionSheetAlert(title: value.title, message: nil, actions: actions)
    }


}
