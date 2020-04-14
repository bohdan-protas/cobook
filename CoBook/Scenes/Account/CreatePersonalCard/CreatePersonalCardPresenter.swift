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
    func setupSaveCardView()
    func presentPickerController() 
}

private enum Defaults {
    static let imageCompressionQuality: CGFloat = 0.1
}

class CreatePersonalCardPresenter: NSObject, BasePresenter {

    // MARK: - Properties

    private weak var view: CreatePersonalCardView?
    private var viewDataSource: TableDataSource<CreatePersonalCardDataSourceConfigurator>?
    private var viewDataSourceConfigurator: CreatePersonalCardDataSourceConfigurator?

    var personalCardDetailsModel: CreatePersonalCard.DetailsModel {
        didSet {
            let isRequiredDataFilled = (
                !(personalCardDetailsModel.avatarImage == nil) &&
                !(personalCardDetailsModel.position ?? "").isEmpty &&
                !(personalCardDetailsModel.practiseType == nil) &&
                !(personalCardDetailsModel.city == nil) &&
                !(personalCardDetailsModel.region == nil) &&
                !(personalCardDetailsModel.description ?? "").isEmpty &&
                !(personalCardDetailsModel.contactTelephone ?? "").isEmpty &&
                !(personalCardDetailsModel.contactEmail ?? "").isEmpty
            )

            view?.setSaveButtonEnabled(isRequiredDataFilled)
            updateViewDataSource()
        }
    }
    
    // MARK: - View Lifecycle

    init(detailsModel: CreatePersonalCard.DetailsModel? = nil) {
        self.personalCardDetailsModel = detailsModel ?? CreatePersonalCard.DetailsModel()
    }

    // MARK: - Public

    func attachView(_ view: CreatePersonalCardView) {
        self.view = view
        self.viewDataSourceConfigurator = CreatePersonalCardDataSourceConfigurator(presenter: self)
        self.viewDataSource = TableDataSource(tableView: view.tableView, configurator: viewDataSourceConfigurator)
    }

    func detachView() {
        self.view = nil
        self.viewDataSource = nil
        self.viewDataSource = nil
    }

    func onViewDidLoad() {
        view?.setupSaveCardView()
        setupDataSource()
    }

    func createPerconalCard() {
        view?.startLoading(text: "Створення...")
        let params = CreatePersonalCardParametersApiModel(model: personalCardDetailsModel)
        
        APIClient.default.createPersonalCard(parameters: params) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                strongSelf.view?.stopLoading(success: true, completion: {
                    AppStorage.State.isNeedToUpdateAccountData = true
                    strongSelf.view?.popController()
                })
            case let .failure(error):
                strongSelf.view?.stopLoading()
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
    
    func updateViewDataSource() {
        let photosSection = Section<CreatePersonalCard.Cell>(items: [
            .avatarManagment(model: CardAvatarManagmentCellModel(sourceType: .personalCard, imagePath: personalCardDetailsModel.avatarImage?.sourceUrl))
        ])

        let activitySection = Section<CreatePersonalCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Діяльність:"),
            .textField(model: TextFieldModel(text: personalCardDetailsModel.position, placeholder: "Займана посада", associatedKeyPath: \CreatePersonalCard.DetailsModel.position, keyboardType: .default)),
            .actionField(model: ActionFieldModel(text: personalCardDetailsModel.practiseType?.title, placeholder: "Вид діяльності", actionTypeId: CreatePersonalCard.ActionType.activityType.rawValue)),
            .actionField(model: ActionFieldModel(text: personalCardDetailsModel.city?.name, placeholder: "Місто проживання", actionTypeId: CreatePersonalCard.ActionType.placeOfLiving.rawValue)),
            .actionField(model: ActionFieldModel(text: personalCardDetailsModel.region?.name, placeholder: "Регіон діяльності", actionTypeId: CreatePersonalCard.ActionType.activityRegion.rawValue)),
            .textView(model: TextFieldModel(text: personalCardDetailsModel.description, placeholder: "Опис діяльності", associatedKeyPath: \CreatePersonalCard.DetailsModel.description, keyboardType: .default))
        ])

        let contactsSection = Section<CreatePersonalCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Діяльність компанії:"),
            .textField(model: TextFieldModel(text: personalCardDetailsModel.contactTelephone, placeholder: "Робочий номер телефону", associatedKeyPath: \CreatePersonalCard.DetailsModel.contactTelephone, keyboardType: .phonePad)),
            .textField(model: TextFieldModel(text: personalCardDetailsModel.contactEmail, placeholder: "Робочий емайл для звязку", associatedKeyPath: \CreatePersonalCard.DetailsModel.contactEmail, keyboardType: .emailAddress)),
            .title(text: "Соціальні мережі:"),
            .socials,
        ])

        let interestsSection = Section<CreatePersonalCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Інтереси(для рекомендацій):"),
            .interests
        ])

        viewDataSource?.sections = [photosSection, activitySection, contactsSection, interestsSection]
    }


}

// MARK: - Use cases

private extension CreatePersonalCardPresenter {

    func setupDataSource() {
        let group = DispatchGroup()

        var practicesTypesListRequestError: Error?
        var interestsListRequestError: Error?

        var practicies: [PracticeModel] = []
        var interests: [InterestModel] = []

        view?.startLoading(text: "Завантаження")

        // fetch practices
        group.enter()
        APIClient.default.practicesTypesListRequest { (result) in
            switch result {
            case let .success(response):
                practicies = (response ?? []).compactMap { PracticeModel(id: $0.id, title: $0.title) }
                group.leave()
            case let .failure(error):
                practicesTypesListRequestError = error
                group.leave()
            }
        }

        // fetch interests
        group.enter()
        APIClient.default.interestsListRequest { (result) in
            switch result {
            case let .success(response):
                interests = (response ?? []).compactMap { InterestModel(id: $0.id, title: $0.title, isSelected: false) }
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

            self?.personalCardDetailsModel.practices = practicies

            let fetchedInterests: [InterestModel] = interests.compactMap { fetched in
                let isSelected = strongSelf.personalCardDetailsModel.interests.contains(where: { (selected) -> Bool in
                    return selected.id == fetched.id
                })
                return InterestModel(id: fetched.id, title: fetched.title, isSelected: isSelected )
            }
            self?.personalCardDetailsModel.interests = fetchedInterests

            if practicesTypesListRequestError != nil {
                strongSelf.view?.errorAlert(message: practicesTypesListRequestError?.localizedDescription)
                return
            }

            if interestsListRequestError != nil  {
                strongSelf.view?.errorAlert(message: interestsListRequestError?.localizedDescription)
            }

            strongSelf.view?.setupSaveCardView()
            strongSelf.view?.tableView.reloadData()
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
                strongSelf.personalCardDetailsModel.avatarImage = response
                strongSelf.view?.tableView.reloadData()
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

}

// MARK: - InterestsSelectionTableViewCell Delegation

extension CreatePersonalCardPresenter: InterestsSelectionTableViewCellDataSource {

    var interests: [InterestModel] {
        get {
            return personalCardDetailsModel.interests
        }
        set {
            personalCardDetailsModel.interests = newValue
        }
    }

}

// MARK: - TextViewTableViewCell Delegation

extension CreatePersonalCardPresenter: TextViewTableViewCellDelegate {

    func textViewTableViewCell(_ cell: TextViewTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {
        guard let keyPath = keyPath as? WritableKeyPath<CreatePersonalCard.DetailsModel, String?> else {
            return
        }
        personalCardDetailsModel[keyPath: keyPath] = text
    }


}

// MARK: - TextFieldTableViewCell Delegation

extension CreatePersonalCardPresenter: TextFieldTableViewCellDelegate, TextFieldTableViewCellDataSource {

    var pickerList: [String] {
        return personalCardDetailsModel.practices.compactMap { $0.title }
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {
        guard let keyPath = keyPath as? WritableKeyPath<CreatePersonalCard.DetailsModel, String?> else {
            return
        }
        personalCardDetailsModel[keyPath: keyPath] = text
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?) {
        guard let action = CreatePersonalCard.ActionType.init(rawValue: identifier ?? "") else {
            return
        }

        switch action {
        case .activityType:
            let selectedPracticeName = cell.textField.text
            let selectedPractice = personalCardDetailsModel.practices.first(where: { $0.title == selectedPracticeName })
            personalCardDetailsModel.practiseType = selectedPractice
        case .placeOfLiving:
            let filter = GMSAutocompleteFilter()
            filter.type = .city
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedCity) in
                if let cityId = fetchedCity.placeID {
                    cell.textField.text = fetchedCity.name
                    self?.personalCardDetailsModel.city = PlaceModel(googlePlaceId: cityId, name: fetchedCity.name)
                }
            })

        case .activityRegion:
            let filter = GMSAutocompleteFilter()
            filter.type = .region
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedRegion) in
                if let regionId = fetchedRegion.placeID {
                    cell.textField.text = fetchedRegion.name
                    self?.personalCardDetailsModel.region = PlaceModel(googlePlaceId: regionId, name: fetchedRegion.name)
                }
            })
        }

    }


}

// MARK: - SocialsListTableViewCell delegation

extension CreatePersonalCardPresenter: SocialsListTableViewCellDelegate, SocialsListTableViewCellDataSource {

    var socials: [Social.ListItem] {
        get {
            return personalCardDetailsModel.socials
        }
        set {
            personalCardDetailsModel.socials = newValue
        }
    }


    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didSelectedSocialItem item: Social.ListItem) {
        switch item {
        case .add:
            view?.newSocialAlert(name: nil, link: nil) { (name, strUrl) in
                guard let url = URL.init(string: strUrl ?? ""), UIApplication.shared.canOpenURL(url) else {
                    self.view?.errorAlert(message: "Посилання має хибний формат")
                    return
                }

                let newItem = Social.ListItem.view(model: Social.Model(title: name, url: url))
                cell.create(socialListItem: newItem)
            }
        default:
            break
        }
    }

    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didLongPresseddOnItem value: Social.Model, at indexPath: IndexPath) {
        let actions: [UIAlertAction] = [
            .init(title: "Видалити", style: .destructive, handler: { (_) in
                cell.deleteAt(indexPath: indexPath)
            }),
            .init(title: "Змінити", style: .default, handler: { (_) in
                self.view?.newSocialAlert(name: value.title, link: value.url?.absoluteString) { (name, strUrl) in
                    guard let name = name, let url = URL.init(string: strUrl ?? ""), UIApplication.shared.canOpenURL(url) else {
                        self.view?.errorAlert(message: "Посилання має хибний формат")
                        return
                    }

                    let newItem = Social.ListItem.view(model: Social.Model(title: name, url: url))
                    cell.updateAt(indexPath: indexPath, with: newItem)
                }
            }),
            .init(title: "Відмінити", style: .cancel, handler: { (_) in
                Log.debug("Cancel")
            })

        ]
        view?.actionSheetAlert(title: value.title, message: nil, actions: actions)
    }


}

// MARK: - CardAvatarPhotoManagmentTableViewCellDelegate

extension CreatePersonalCardPresenter: CardAvatarPhotoManagmentTableViewCellDelegate {
    
    func didChangeAvatarPhoto(_ view: CardAvatarPhotoManagmentTableViewCell) {
        self.view?.presentPickerController()
    }


}
