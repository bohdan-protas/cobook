//
//  CreateBusinessCardPresenter.swift
//  CoBook
//
//  Created by protas on 3/31/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces


protocol CreateBusinessCardView: AlertDisplayableView, LoadDisplayableView, NavigableView, CardAvatarPhotoManagmentTableViewCellDelegate, CardBackgroundManagmentTableViewCellDelegate {
    var tableView: UITableView! { get set }
    func set(dataSource: DataSource<CreateBusinessCardDataSourceConfigurator>?)

    func showAutocompleteController(filter: GMSAutocompleteFilter, completion: ((GMSPlace) -> Void)?)
    func setupSaveCardView()
    func setSaveButtonEnabled(_ isEnabled: Bool)
    func showSearchEmployersControlelr()
}

// MARK: - Defaults

fileprivate enum Defaults {
    static let avatarImageCompressionQuality: CGFloat = 0.1
    static let bgImageCompressionQuality: CGFloat = 0.1
}

// MARK: - CreateBusinessCardPresenter

class CreateBusinessCardPresenter: NSObject, BasePresenter {

    var view: CreateBusinessCardView?
    private var viewDataSource: DataSource<CreateBusinessCardDataSourceConfigurator>?

    /// Flag for instantiate current state
    private let isEditing: Bool

    /// Business logic
    private var businessCardDetailsModel: CreateBusinessCard.DetailsModel {
        didSet {

            let whitespaceCharacterSet = CharacterSet.whitespaces
            let isRequiredDataFilled = (
                !(businessCardDetailsModel.avatarImage == nil) &&
                !(businessCardDetailsModel.backgroudImage == nil) &&
                !(businessCardDetailsModel.companyName ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty &&
                !(businessCardDetailsModel.practiseType == nil) &&
                !(businessCardDetailsModel.contactTelephone ?? "").isEmpty &&
                !(businessCardDetailsModel.companyEmail ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty &&
                !(businessCardDetailsModel.companyWebSite ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty &&
                !(businessCardDetailsModel.city == nil) &&
                !(businessCardDetailsModel.region == nil) &&
                !(businessCardDetailsModel.address == nil) &&
                !(businessCardDetailsModel.schedule ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty &&
                !(businessCardDetailsModel.description ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty
            )

            view?.setSaveButtonEnabled(isRequiredDataFilled)
            updateViewDataSource()
        }
    }

    // MARK: - Object Lifecycle

    override init() {
        self.isEditing = false
        self.businessCardDetailsModel = CreateBusinessCard.DetailsModel()
    }

    init(detailsModel: CreateBusinessCard.DetailsModel) {
        self.isEditing = true
        self.businessCardDetailsModel = detailsModel
    }

    // MARK: - Public

    func attachView(_ view: CreateBusinessCardView) {
        self.view = view
        self.viewDataSource = DataSource(configurator: dataSourceConfigurator)
        view.set(dataSource: viewDataSource)
    }

    func detachView() {
        self.view = nil
    }

    func onViewDidLoad() {
        setupDataSource()
    }

    func onCreationAction() {
        if isEditing {
            updateBusinessCard()
        } else {
            createBusinessCard()
        }
    }

    func addEmploy(model: EmployeeModel?) {
        if let model = model {
            if businessCardDetailsModel.employers.contains(where: { $0 == model }) {
                view?.errorAlert(message: "Error.employAreadyAdded".localized)
                return
            }

            businessCardDetailsModel.employers.append(model)
            view?.tableView.reloadData()
        } else {
            Log.error("User not defined")
        }
    }

    func uploadCompanyAvatar(image: UIImage?) {
        guard let imageData = image?.jpegData(compressionQuality: Defaults.avatarImageCompressionQuality) else {
            Log.error("Cannot find selected image data!")
            view?.errorAlert(message: "Error.photoLoading.message".localized)
            return
        }

        APIClient.default.upload(imageData: imageData) { [weak self] (result) in
            guard let strongSelf = self else { return }

            switch result {
            case let .success(response):
                strongSelf.businessCardDetailsModel.avatarImage = response
                strongSelf.businessCardDetailsModel.avatarImageData = imageData
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func uploadCompanyBg(image: UIImage?) {
        guard let imageData = image?.jpegData(compressionQuality: Defaults.avatarImageCompressionQuality) else {
            Log.error("Cannot find selected image data!")
            view?.errorAlert(message: "Error.photoLoading.message".localized)
            return
        }

        APIClient.default.upload(imageData: imageData) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case let .success(response):
                strongSelf.businessCardDetailsModel.backgroudImage = response
                strongSelf.businessCardDetailsModel.backgroudImageData = imageData
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}

// MARK: - Data Source Configuration

extension CreateBusinessCardPresenter {

    private func updateViewDataSource() {
        let photosSection = Section<CreateBusinessCard.Cell>(items: [
            .backgroundImageManagment(model: BackgroundManagmentImageCellModel(imagePath: businessCardDetailsModel.backgroudImage?.sourceUrl,
                                                                               imageData: businessCardDetailsModel.backgroudImageData)),

            .avatarManagment(model: CardAvatarManagmentCellModel(sourceType: .businessCard,
                                                                 imagePath: businessCardDetailsModel.avatarImage?.sourceUrl,
                                                                 imageData: businessCardDetailsModel.avatarImageData))
        ])

        let mainDataSection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "BusinessCard.section.mainData".localized),
            .textField(model: TextFieldModel(text: businessCardDetailsModel.companyName,
                                             placeholder: "TextInput.placeholder.companyName".localized,
                                             associatedKeyPath: \CreateBusinessCard.DetailsModel.companyName,
                                             keyboardType: .default)),
            .actionField(model: ActionFieldModel(text: businessCardDetailsModel.practiseType?.title,
                                                 placeholder: "TextInput.placeholder.activityType".localized,
                                                 actionTypeId: CreateBusinessCard.ActionType.practice.rawValue)),
            .textField(model: TextFieldModel(text: businessCardDetailsModel.contactTelephone,
                                             placeholder: "TextInput.placeholder.workingPhoneNumber".localized,
                                             associatedKeyPath: \CreateBusinessCard.DetailsModel.contactTelephone,
                                             keyboardType: .phonePad)),
            .textField(model: TextFieldModel(text: businessCardDetailsModel.companyWebSite,
                                             placeholder: "TextInput.placeholder.website".localized,
                                             associatedKeyPath: \CreateBusinessCard.DetailsModel.companyWebSite,
                                             keyboardType: .URL)),
            .textField(model: TextFieldModel(text: businessCardDetailsModel.companyEmail,
                                             placeholder: "TextInput.placeholder.email".localized,
                                             associatedKeyPath: \CreateBusinessCard.DetailsModel.companyEmail,
                                             keyboardType: .emailAddress))
        ])

        let companyActivitySection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "BusinessCard.section.companyActivity".localized),
            .actionField(model: ActionFieldModel(text: businessCardDetailsModel.city?.name,
                                                 placeholder: "TextInput.placeholder.cityLocation".localized,
                                                 actionTypeId: CreateBusinessCard.ActionType.city.rawValue)),
            .actionField(model: ActionFieldModel(text: businessCardDetailsModel.region?.name,
                                                 placeholder: "TextInput.placeholder.activityLocation".localized,
                                                 actionTypeId: CreateBusinessCard.ActionType.region.rawValue)),
            .actionField(model: ActionFieldModel(text: businessCardDetailsModel.address?.name,
                                                 placeholder: "TextInput.placeholder.street".localized,
                                                 actionTypeId: CreateBusinessCard.ActionType.address.rawValue)),
            .textField(model: TextFieldModel(text: businessCardDetailsModel.schedule,
                                             placeholder: "TextInput.placeholder.workSchedule".localized,
                                             associatedKeyPath: \CreateBusinessCard.DetailsModel.schedule,
                                             keyboardType: .default))
        ])

        let aboutCompacySection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "BusinessCard.section.aboutCompany.title".localized),
            .textView(model: TextFieldModel(text: businessCardDetailsModel.description,
                                            placeholder: "TextInput.placeholder.detailDescription".localized,
                                            associatedKeyPath: \CreateBusinessCard.DetailsModel.description,
                                            keyboardType: .default))
        ])

        let socialSection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "BusinessCard.section.companyInSocials.title".localized),
            .socials,
        ])

        var employersSection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "BusinessCard.section.companyEmployers.title".localized),
            .employersSearch,
        ])
        if !businessCardDetailsModel.employers.isEmpty {
            employersSection.items.append(.employersList)
        }

        let interestsSection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "BusinessCard.section.interests.title".localized),
            .interests
        ])

        viewDataSource?.sections = [photosSection, mainDataSection, companyActivitySection, aboutCompacySection, socialSection, employersSection, interestsSection]
    }


}

// MARK: - Use cases

private extension CreateBusinessCardPresenter {

    func updateBusinessCard() {
        view?.startLoading(text: "Loading.creating.title".localized)

        let parameters = CreateBusinessCardParametersApiModel(model: businessCardDetailsModel)
        APIClient.default.updateBusinessCard(parameters: parameters) { [weak self] (result) in
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

    func createBusinessCard() {
        view?.startLoading(text: "Loading.creating.title".localized)

        let parameters = CreateBusinessCardParametersApiModel(model: businessCardDetailsModel)
        APIClient.default.createBusinessCard(parameters: parameters) { [weak self] (result) in
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

    func setupDataSource() {
        let group = DispatchGroup()
        var errors = [Error]()

        view?.startLoading(text: "Loading.loading.title".localized)

        // fetch practices
        group.enter()
        APIClient.default.practicesTypesListRequest { [weak self] (result) in
            switch result {
            case let .success(response):
                self?.businessCardDetailsModel.practices = (response ?? []).compactMap { PracticeModel(id: $0.id, title: $0.title) }
                group.leave()
            case let .failure(error):
                errors.append(error)
                group.leave()
            }
        }

        // fetch interests
        group.enter()
        APIClient.default.interestsListRequest { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case let .success(response):

                let interests = (response ?? []).compactMap { InterestModel(id: $0.id, title: $0.title) }

                let fetchedInterests: [InterestModel] = interests.compactMap { fetched in
                    let isSelected = strongSelf.businessCardDetailsModel.interests.contains(where: { (selected) -> Bool in
                        return selected.id == fetched.id
                    })
                    return InterestModel(id: fetched.id, title: fetched.title, isSelected: isSelected )
                }
                strongSelf.businessCardDetailsModel.interests = fetchedInterests
                group.leave()
            case let .failure(error):
                errors.append(error)
                group.leave()
            }
        }

        if let id = businessCardDetailsModel.cardId {
            // fetch employers
            group.enter()
            APIClient.default.employeeList(cardId: id) { [weak self] (result) in
                switch result {
                case let .success(response):
                    self?.businessCardDetailsModel.employers = (response ?? []).compactMap { EmployeeModel(userId: $0.userId,
                                                                                                           cardId: $0.cardId,
                                                                                                           firstName: $0.firstName,
                                                                                                           lastName: $0.lastName,
                                                                                                           avatar: $0.avatar?.sourceUrl,
                                                                                                           position: $0.position,
                                                                                                           telephone: $0.telephone?.number,
                                                                                                           practiceType: PracticeModel(id: $0.practiceType?.id, title: $0.practiceType?.title)) }
                    group.leave()
                case let .failure(error):
                    errors.append(error)
                    group.leave()
                }
            }
        }

        // setup data source
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            if !errors.isEmpty {
                self?.view?.errorAlert(message: errors.first?.localizedDescription)
            }

            strongSelf.view?.setupSaveCardView()
            strongSelf.view?.tableView.reloadData()
        }
    }

    
}

// MARK: - EmployersPreviewHorizontalListTableViewCellDataSource

extension CreateBusinessCardPresenter: EmployersPreviewHorizontalListTableViewCellDataSource, EmployersPreviewHorizontalListTableViewCellDelegate {

    func didLastEmployDeleted(_ cell: EmployersPreviewHorizontalListTableViewCell) {
        if let indexPath = view?.tableView.indexPath(for: cell) {
            view?.tableView.beginUpdates()
            view?.tableView.deleteRows(at: [indexPath], with: .top)
            view?.tableView.endUpdates()
        }

    }

    var employers: [EmployeeModel] {
        get {
            return businessCardDetailsModel.employers
        }
        set {
            businessCardDetailsModel.employers = newValue
        }
    }


}

// MARK: - CardBackgroundManagmentTableViewCellDelegate

extension CreateBusinessCardPresenter: SearchTableViewCellDelegate {

    func onSearchTapped(_ cell: SearchTableViewCell) {
        view?.showSearchEmployersControlelr()
    }


}

// MARK: - TextFieldTableViewCellDelegate

extension CreateBusinessCardPresenter: TextFieldTableViewCellDelegate, TextFieldTableViewCellDataSource {

    var pickerList: [String] {
        return businessCardDetailsModel.practices.compactMap { $0.title }
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {
        guard let keyPath = keyPath as? WritableKeyPath<CreateBusinessCard.DetailsModel, String?> else {
            return
        }
        businessCardDetailsModel[keyPath: keyPath] = text
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?) {
        guard let action = CreateBusinessCard.ActionType.init(rawValue: identifier ?? "") else {
            return
        }

        switch action {
        case .practice:
            let selectedPracticeName = cell.textField.text
            let selectedPractice = businessCardDetailsModel.practices.first(where: { $0.title == selectedPracticeName })
            businessCardDetailsModel.practiseType = selectedPractice

        case .city:
            let filter = GMSAutocompleteFilter()
            filter.type = .city
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedCity) in
                if let id = fetchedCity.placeID {
                    cell.textField.text = fetchedCity.name
                    self?.businessCardDetailsModel.city = PlaceModel(googlePlaceId: id, name: fetchedCity.name)
                }
            })

        case .region:
            let filter = GMSAutocompleteFilter()
            filter.type = .region
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedRegion) in
                if let id = fetchedRegion.placeID {
                    cell.textField.text = fetchedRegion.name
                    self?.businessCardDetailsModel.region = PlaceModel(googlePlaceId: id, name: fetchedRegion.name)
                }
            })

        case .address:
            let filter = GMSAutocompleteFilter()
            filter.type = .address
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedAddress) in
                if let id = fetchedAddress.placeID {
                    cell.textField.text = fetchedAddress.name
                    self?.businessCardDetailsModel.address = PlaceModel(googlePlaceId: id, name: fetchedAddress.name)
                }
            })
        }
    }


}

// MARK: - TextViewTableViewCellDelegate

extension CreateBusinessCardPresenter: TextViewTableViewCellDelegate {
    
    func textViewTableViewCell(_ cell: TextViewTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {
        guard let keyPath = keyPath as? WritableKeyPath<CreateBusinessCard.DetailsModel, String?> else {
            return
        }
        businessCardDetailsModel[keyPath: keyPath] = text
    }


}

// MARK: - InterestsSelectionTableViewCellDataSource

extension CreateBusinessCardPresenter: InterestsSelectionTableViewCellDataSource, InterestsSelectionTableViewCellDelegate {

    func interestsSelectionTableViewCell(_ cell: TagsListTableViewCell, didSelectInterestAt index: Int) {
        businessCardDetailsModel.interests[safe: index]?.isSelected = true
    }

    func interestsSelectionTableViewCell(_ cell: TagsListTableViewCell, didDeselectInterestAt index: Int) {
        businessCardDetailsModel.interests[safe: index]?.isSelected = false
    }

    func dataSourceWith(identifier: String?) -> [InterestModel] {
        return businessCardDetailsModel.interests
    }


}

// MARK: - SocialsListTableViewCellDelegate

extension CreateBusinessCardPresenter: SocialsListTableViewCellDelegate, SocialsListTableViewCellDataSource {

    var socials: [Social.ListItem] {
        get {
            return businessCardDetailsModel.socials
        }
        set {
            businessCardDetailsModel.socials = newValue
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
                        self.view?.errorAlert(message: "Error.Social.badLink.message".localized)
                        return
                    }

                    let newItem = Social.ListItem.view(model: Social.Model(title: name, url: url))
                    cell.updateAt(indexPath: indexPath, with: newItem)
                }
            }),
            .init(title: "AlertAction.Cancel".localized, style: .cancel, handler: nil)
        ]

        view?.actionSheetAlert(title: value.title, message: nil, actions: actions)
    }


}


