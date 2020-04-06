//
//  CreateBusinessCardPresenter.swift
//  CoBook
//
//  Created by protas on 3/31/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces

protocol CreateBusinessCardView: AlertDisplayableView, LoadDisplayableView, NavigableView {
    var tableView: UITableView! { get set }
    func setupLayout()
    func showAutocompleteController(filter: GMSAutocompleteFilter, completion: ((GMSPlace) -> Void)?)
    func showPickerController(completion: ((UIImage) -> Void)?)
    func setupSaveCardView()
    func setSaveButtonEnabled(_ isEnabled: Bool)
    func showSearchEmployersControlelr()
}

private enum Defaults {
    static let avatarImageCompressionQuality: CGFloat = 0.1
    static let bgImageCompressionQuality: CGFloat = 0.1
}

class CreateBusinessCardPresenter: NSObject, BasePresenter {

    // MARK: Properties
    private var view: CreateBusinessCardView?
    private var viewDataSource: TableDataSource<CreateBusinessCardDataSourceConfigurator>?
    private var viewDataSourceConfigurator: CreateBusinessCardDataSourceConfigurator?

    var businessCardDetailsModel: CreateBusinessCard.DetailsModel {
        didSet {
            let isRequiredDataFilled = (
                !(businessCardDetailsModel.avatarImage == nil) &&
                !(businessCardDetailsModel.backgroudImage == nil) &&
                !(businessCardDetailsModel.companyName ?? "").isEmpty &&
                !(businessCardDetailsModel.practiseType == nil) &&
                !(businessCardDetailsModel.contactTelephone ?? "").isEmpty &&
                !(businessCardDetailsModel.companyEmail ?? "").isEmpty &&
                !(businessCardDetailsModel.companyWebSite ?? "").isEmpty &&
                !(businessCardDetailsModel.city == nil) &&
                !(businessCardDetailsModel.region == nil) &&
                !(businessCardDetailsModel.address == nil) &&
                !(businessCardDetailsModel.schedule ?? "").isEmpty &&
                !(businessCardDetailsModel.description ?? "").isEmpty
            )

            view?.setSaveButtonEnabled(isRequiredDataFilled)
            updateViewDataSource()
        }
    }

    init(detailsModel: CreateBusinessCard.DetailsModel? = nil) {
        self.businessCardDetailsModel = detailsModel ?? CreateBusinessCard.DetailsModel()
    }

    // MARK: Public
    func attachView(_ view: CreateBusinessCardView) {
        self.view = view
        self.viewDataSourceConfigurator = CreateBusinessCardDataSourceConfigurator(presenter: self)
        self.viewDataSource = TableDataSource(tableView: view.tableView, configurator: viewDataSourceConfigurator)
    }

    func detachView() {
        self.view = nil
        self.viewDataSource = nil
        self.viewDataSource = nil
    }

    func onViewDidLoad() {
        view?.setupLayout()
        view?.setupSaveCardView()
        setupDataSource()
    }

    func createBusinessCard() {
        let parameters = CreateBusinessCardParametersApiModel(model: businessCardDetailsModel)
        
        view?.startLoading(text: "Створення...")
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

    func addEmploy(model: CardPreviewModel?) {
        if let model = model {
            if businessCardDetailsModel.employers.contains(where: { $0 == model }) {
                view?.errorAlert(message: "Вибраний працівник вже доданий")
                return
            }

            businessCardDetailsModel.employers.append(model)
            view?.tableView.reloadData()
        } else {
            Log.error("User not defined")
        }
    }

}

// MARK: - Privates
private extension CreateBusinessCardPresenter {

    func updateViewDataSource() {
        let photosSection = Section<CreateBusinessCard.Cell>(items: [
            .backgroundImageManagment(model: BackgroundManagmentImageCellModel(imagePath: businessCardDetailsModel.backgroudImage?.sourceUrl)),
            .avatarManagment(model: CardAvatarManagmentCellModel(sourceType: .businessCard, imagePath: businessCardDetailsModel.avatarImage?.sourceUrl))
        ])

        let mainDataSection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Основні дані:"),
            .textField(model: TextFieldModel(text: businessCardDetailsModel.companyName, placeholder: "Назва компанії", associatedKeyPath: \CreateBusinessCard.DetailsModel.companyName, keyboardType: .default)),
            .actionField(model: ActionFieldModel(text: businessCardDetailsModel.practiseType?.title, placeholder: "Вид діяльності", actionTypeId: CreateBusinessCard.ActionType.practice.rawValue)),
            .textField(model: TextFieldModel(text: businessCardDetailsModel.contactTelephone, placeholder: "Робочий номер телефону", associatedKeyPath: \CreateBusinessCard.DetailsModel.contactTelephone, keyboardType: .phonePad)),
            .textField(model: TextFieldModel(text: businessCardDetailsModel.companyWebSite, placeholder: "Веб сайт", associatedKeyPath: \CreateBusinessCard.DetailsModel.companyWebSite, keyboardType: .URL)),
            .textField(model: TextFieldModel(text: businessCardDetailsModel.companyEmail, placeholder: "Емейл", associatedKeyPath: \CreateBusinessCard.DetailsModel.companyEmail, keyboardType: .emailAddress))
        ])

        let companyActivitySection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Діяльність компанії:"),
            .actionField(model: ActionFieldModel(text: businessCardDetailsModel.city?.name, placeholder: "Місто розташування", actionTypeId: CreateBusinessCard.ActionType.city.rawValue)),
            .actionField(model: ActionFieldModel(text: businessCardDetailsModel.region?.name, placeholder: "Місто діяльності", actionTypeId: CreateBusinessCard.ActionType.region.rawValue)),
            .actionField(model: ActionFieldModel(text: businessCardDetailsModel.address?.name, placeholder: "Вулиця", actionTypeId: CreateBusinessCard.ActionType.address.rawValue)),
            .textField(model: TextFieldModel(text: businessCardDetailsModel.schedule, placeholder: "Графік роботи (дні та години)", associatedKeyPath: \CreateBusinessCard.DetailsModel.schedule, keyboardType: .default))
        ])

        let aboutCompacySection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Про компанію:"),
            .textView(model: TextFieldModel(text: businessCardDetailsModel.description, placeholder: "Детальний опис", associatedKeyPath: \CreateBusinessCard.DetailsModel.description, keyboardType: .default))
        ])

        let socialSection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Компанія у соцмережах:"),
            .socials,
        ])

        var employersSection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Працівники компанії:"),
            .employersSearch,
        ])
        if !businessCardDetailsModel.employers.isEmpty {
            employersSection.items.append(.employersList)
        }


        let interestsSection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Інтереси(для рекомендацій):"),
            .interests
        ])

        viewDataSource?.sections = [photosSection, mainDataSection, companyActivitySection, aboutCompacySection, socialSection, employersSection, interestsSection]
    }


}

// MARK: - Use cases
private extension CreateBusinessCardPresenter {

    func createPersonalCard() {

    }

    func uploadCompanyAvatar(image: UIImage?) {
        guard let imageData = image?.jpegData(compressionQuality: Defaults.avatarImageCompressionQuality) else {
            Log.error("Cannot find selected image data!")
            view?.errorAlert(message: "Помилка завантаження фото")
            return
        }

        view?.startLoading()
        APIClient.default.upload(imageData: imageData) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            switch result {
            case let .success(response):
                strongSelf.businessCardDetailsModel.avatarImage = response
                strongSelf.view?.tableView.reloadData()
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func uploadCompanyBg(image: UIImage?) {
        guard let imageData = image?.jpegData(compressionQuality: Defaults.avatarImageCompressionQuality) else {
            Log.error("Cannot find selected image data!")
            view?.errorAlert(message: "Помилка завантаження фото")
            return
        }

        view?.startLoading()
        APIClient.default.upload(imageData: imageData) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            switch result {
            case let .success(response):
                strongSelf.businessCardDetailsModel.backgroudImage = response
                strongSelf.view?.tableView.reloadData()
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

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

            self?.businessCardDetailsModel.practices = practicies
            self?.businessCardDetailsModel.interests = interests

            if practicesTypesListRequestError != nil {
                strongSelf.view?.errorAlert(message: practicesTypesListRequestError?.localizedDescription)
                return
            }

            if interestsListRequestError != nil  {
                strongSelf.view?.errorAlert(message: interestsListRequestError?.localizedDescription)
            }

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

    var employers: [CardPreviewModel] {
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

// MARK: - CardBackgroundManagmentTableViewCellDelegate
extension CreateBusinessCardPresenter: CardBackgroundManagmentTableViewCellDelegate {

    func didTappedOnPhoto(_ cell: CardBackgroundManagmentTableViewCell) {
        self.view?.showPickerController(completion: { (fetchedImage) in
            self.uploadCompanyBg(image: fetchedImage)
        })
    }


}

// MARK: - CardAvatarPhotoManagmentTableViewCellDelegate
extension CreateBusinessCardPresenter: CardAvatarPhotoManagmentTableViewCellDelegate {

    func cardAvatarPhotoManagmentView(_ view: CardAvatarPhotoManagmentTableViewCell, didSelectAction sender: UIButton) {
        self.view?.showPickerController(completion: { (fetchedImage) in
            self.uploadCompanyAvatar(image: fetchedImage)
        })
    }

    func cardAvatarPhotoManagmentView(_ view: CardAvatarPhotoManagmentTableViewCell, didChangeAction sender: UIButton) {
        self.view?.showPickerController(completion: { (fetchedImage) in
            self.uploadCompanyAvatar(image: fetchedImage)
        })
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
extension CreateBusinessCardPresenter: InterestsSelectionTableViewCellDataSource {

    var interests: [InterestModel] {
        get {
            return businessCardDetailsModel.interests
        }
        set {
            businessCardDetailsModel.interests = newValue
        }
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
            .init(title: "Відмінити", style: .cancel, handler: nil)
        ]

        view?.actionSheetAlert(title: value.title, message: nil, actions: actions)
    }


}


