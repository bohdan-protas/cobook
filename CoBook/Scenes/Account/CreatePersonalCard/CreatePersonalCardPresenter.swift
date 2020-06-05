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

protocol CreatePersonalCardView: AlertDisplayableView, LoadDisplayableView, NavigableView, CardAvatarPhotoManagmentTableViewCellDelegate {
    var tableView: UITableView! { get set }

    func set(dataSource: DataSource<CreatePersonalCardDataSourceConfigurator>?)
    func showAutocompleteController(filter: GMSAutocompleteFilter, completion: ((GMSPlace) -> Void)?)
    func setSaveButtonEnabled(_ isEnabled: Bool)
    func setupSaveCardView()
}

fileprivate enum Defaults {
    static let imageCompressionQuality: CGFloat = 0.1
}

class CreatePersonalCardPresenter: NSObject, BasePresenter {

    // MARK: - Properties

    weak var view: CreatePersonalCardView?
    private var viewDataSource: DataSource<CreatePersonalCardDataSourceConfigurator>?

    var personalCardDetailsModel: CreatePersonalCard.DetailsModel {
        didSet {
            let isRequiredDataFilled = (
                !(personalCardDetailsModel.avatarImage == nil) &&
                !(personalCardDetailsModel.position ?? "").isEmpty &&
                !(personalCardDetailsModel.practiseType == nil) &&
                !(personalCardDetailsModel.city == nil) &&
                !(personalCardDetailsModel.region == nil) &&
                !(personalCardDetailsModel.description ?? "").trimmingCharacters(in: CharacterSet.whitespaces).isEmpty &&
                !(personalCardDetailsModel.contactTelephone ?? "").trimmingCharacters(in: CharacterSet.whitespaces).isEmpty &&
                !(personalCardDetailsModel.contactEmail ?? "").trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
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
        self.viewDataSource = DataSource(configurator: dataSourceConfigurator)
        view.set(dataSource: viewDataSource)
    }

    func detachView() {
        self.view = nil
        self.viewDataSource = nil
    }

    func onViewDidLoad() {
        setupDataSource()
    }

    func createPerconalCard() {
        if let error = self.validateFields() {
            view?.errorAlert(message: error)
            return
        }

        view?.startLoading(text: "Loading.creating.title".localized)
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

    func uploadUserImage(image: UIImage?) {
        guard let imageData = image?.jpegData(compressionQuality: Defaults.imageCompressionQuality) else {
            Log.error("Cannot find selected image data!")
            view?.errorAlert(message: "Error.photoLoading.message".localized)
            return
        }

        APIClient.default.upload(imageData: imageData) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case let .success(response):
                strongSelf.personalCardDetailsModel.avatarImage = response
                strongSelf.personalCardDetailsModel.avatarImageData = imageData
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}

// MARK: - Privates

private extension CreatePersonalCardPresenter {

    func updateViewDataSource() {
        let photosSection = Section<CreatePersonalCard.Cell>(items: [
            .avatarManagment(model: CardAvatarManagmentCellModel(sourceType: .personalCard, imagePath: personalCardDetailsModel.avatarImage?.sourceUrl, imageData: personalCardDetailsModel.avatarImageData))
        ])

        let activitySection = Section<CreatePersonalCard.Cell>(items: [
            .sectionHeader,
            .title(text: "PersonalCard.Creation.section.activity".localized),
            .textField(model: TextFieldModel(text: personalCardDetailsModel.position,
                                             placeholder: "TextInput.placeholder.occupiedPosition".localized,
                                             associatedKeyPath: \CreatePersonalCard.DetailsModel.position,
                                             keyboardType: .default)),
            .actionField(model: ActionFieldModel(text: personalCardDetailsModel.practiseType?.title,
                                                 placeholder: "TextInput.placeholder.activityType".localized,
                                                 actionTypeId: CreatePersonalCard.ActionType.practiceType.rawValue)),
            .actionField(model: ActionFieldModel(text: personalCardDetailsModel.city?.name,
                                                 placeholder: "TextInput.placeholder.cityOfResidence".localized,
                                                 actionTypeId: CreatePersonalCard.ActionType.placeOfLiving.rawValue)),
            .actionField(model: ActionFieldModel(text: personalCardDetailsModel.region?.name,
                                                 placeholder: "TextInput.placeholder.activityRegion".localized,
                                                 actionTypeId: CreatePersonalCard.ActionType.activityRegion.rawValue)),
            .textView(model: TextFieldModel(text: personalCardDetailsModel.description,
                                            placeholder:"TextInput.placeholder.activityDescription".localized,
                                            associatedKeyPath: \CreatePersonalCard.DetailsModel.description,
                                            keyboardType: .default))
        ])

        let contactsSection = Section<CreatePersonalCard.Cell>(items: [
            .sectionHeader,
            .title(text: "PersonalCard.Creation.section.companyActivity".localized),
            .textField(model: TextFieldModel(text: personalCardDetailsModel.contactTelephone,
                                             placeholder: "TextInput.placeholder.workingPhoneNumber".localized,
                                             associatedKeyPath: \CreatePersonalCard.DetailsModel.contactTelephone,
                                             keyboardType: .phonePad)),
            .textField(model: TextFieldModel(text: personalCardDetailsModel.contactEmail,
                                             placeholder: "TextInput.placeholder.workingEmailNumber".localized,
                                             associatedKeyPath: \CreatePersonalCard.DetailsModel.contactEmail,
                                             keyboardType: .emailAddress)),
            .title(text: "PersonalCard.Creation.section.socials".localized),
            .socials,
        ])

        let interestsSection = Section<CreatePersonalCard.Cell>(items: [
            .sectionHeader,
            .title(text: "PersonalCard.Creation.section.interests".localized),
            .interests
        ])

        viewDataSource?.sections = [photosSection, activitySection, contactsSection, interestsSection]
    }

    func setupDataSource() {
        let group = DispatchGroup()

        var interestsListRequestError: Error?
        var interests: [InterestModel] = []

        view?.startLoading(text: "Loading.loading.title".localized)

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

            let fetchedInterests: [InterestModel] = interests.compactMap { fetched in
                let isSelected = strongSelf.personalCardDetailsModel.interests.contains(where: { (selected) -> Bool in
                    return selected.id == fetched.id
                })
                return InterestModel(id: fetched.id, title: fetched.title, isSelected: isSelected )
            }
            self?.personalCardDetailsModel.interests = fetchedInterests

            if interestsListRequestError != nil  {
                strongSelf.view?.errorAlert(message: interestsListRequestError?.localizedDescription)
            }

            strongSelf.view?.setupSaveCardView()
            strongSelf.view?.tableView.reloadData()
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
        case .practiceType:
            Log.debug("activityType")

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
                    self.view?.errorAlert(message: "Error.Social.badLink.message".localized)
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
            .init(title: "AlertAction.Delete".localized, style: .destructive, handler: { (_) in
                cell.deleteAt(indexPath: indexPath)
            }),
            .init(title: "AlertAction.Change".localized, style: .default, handler: { (_) in
                self.view?.newSocialAlert(name: value.title, link: value.url?.absoluteString) { (name, strUrl) in
                    guard let name = name, let url = URL.init(string: strUrl ?? ""), UIApplication.shared.canOpenURL(url) else {
                        self.view?.errorAlert(message:  "Error.Social.badLink.message".localized)
                        return
                    }

                    let newItem = Social.ListItem.view(model: Social.Model(title: name, url: url))
                    cell.updateAt(indexPath: indexPath, with: newItem)
                }
            }),
            .init(title: "AlertAction.Cancel".localized, style: .cancel, handler: { (_) in
            })

        ]
        view?.actionSheetAlert(title: value.title, message: nil, actions: actions)
    }


}

// MARK: - Privates

private extension CreatePersonalCardPresenter {

    /**
     Validate inputed fields
     - returns: First error of validation or nil (in second case validation successed).
     */
    func validateFields() -> String? {
        if let error = ValidationManager.validate(activityDescr: personalCardDetailsModel.description ?? "") {
            return error
        }

        if let error = ValidationManager.validate(email: personalCardDetailsModel.contactEmail ?? "") {
            return error
        }

        if let error = ValidationManager.validate(telephone: personalCardDetailsModel.contactTelephone ?? "") {
            return error
        }

        if let error = ValidationManager.validate(profession: personalCardDetailsModel.position ?? "") {
            return error
        }

        return nil
    }


}
