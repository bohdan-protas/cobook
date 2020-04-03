//
//  CreateBusinessCardPresenter.swift
//  CoBook
//
//  Created by protas on 3/31/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces

protocol CreateBusinessCardView: AlertDisplayableView, LoadDisplayableView {
    var tableView: UITableView! { get set }
    func showAutocompleteController(filter: GMSAutocompleteFilter, completion: ((GMSPlace) -> Void)?)
    func showPickerController(completion: ((UIImage) -> Void)?)
    func setupSaveCardView()
    func setSaveButtonEnabled(_ isEnabled: Bool)
}

class CreateBusinessCardPresenter: NSObject, BasePresenter {

    enum Defaults {
        static let avatarImageCompressionQuality: CGFloat = 0.1
        static let bgImageCompressionQuality: CGFloat = 0.1
    }

    // MARK: Properties
    private var view: CreateBusinessCardView?
    private var viewDataSource: TableDataSource<CreateBusinessCardDataSourceConfigurator>?
    private var viewDataSourceConfigurator: CreateBusinessCardDataSourceConfigurator?

    var detailsModel: CreateBusinessCard.DetailsModel {
        didSet {
            updateViewDataSource()
        }
    }

    init(detailsModel: CreateBusinessCard.DetailsModel? = nil) {
        self.detailsModel = detailsModel ?? CreateBusinessCard.DetailsModel()
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
        setupDataSource()
    }

}

// MARK: - Privates
private extension CreateBusinessCardPresenter {

    func updateViewDataSource() {
        let mainDataSection = Section<CreateBusinessCard.Cell>(items: [
            .avatarManagment(model: CardAvatarManagmentCellModel(sourceType: .businessCard, imagePath: detailsModel.avatarImage?.sourceUrl)),
            .sectionHeader,
            .title(text: "Основні дані:"),
            .textField(model: TextFieldModel(text: detailsModel.companyName, placeholder: "Назва компанії", associatedKeyPath: \CreateBusinessCard.DetailsModel.companyName, keyboardType: .default)),
            .actionField(model: ActionFieldModel(text: detailsModel.practiseType?.title, placeholder: "Вид діяльності", actionTypeId: CreateBusinessCard.ActionType.practice.rawValue)),
            .textField(model: TextFieldModel(text: detailsModel.contactTelephone, placeholder: "Робочий номер телефону", keyboardType: .phonePad)),
            .textField(model: TextFieldModel(text: detailsModel.companyWebSite, placeholder: "Веб сайт", keyboardType: .URL))
        ])

        let companyActivitySection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Діяльність компанії:"),
            .actionField(model: ActionFieldModel(text: detailsModel.city?.name, placeholder: "Місто розташування", actionTypeId: CreateBusinessCard.ActionType.city.rawValue)),
            .actionField(model: ActionFieldModel(text: detailsModel.region?.name, placeholder: "Місто діяльності", actionTypeId: CreateBusinessCard.ActionType.city.rawValue)),
            .actionField(model: ActionFieldModel(text: detailsModel.address?.name, placeholder: "Вулиця", actionTypeId: CreateBusinessCard.ActionType.city.rawValue)),
            .textField(model: TextFieldModel(text: detailsModel.schedule, placeholder: "Графік роботи (дні та години)", keyboardType: .default))
        ])

        let aboutCompacySection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Про компанію:"),
            .textView(model: TextFieldModel(text: nil, placeholder: "Детальний опис", associatedKeyPath: nil, keyboardType: .default))
        ])

        let socialSection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Компанія у соцмережах:"),
            .socials,
        ])

        let interestsSection = Section<CreateBusinessCard.Cell>(items: [
            .sectionHeader,
            .title(text: "Інтереси(для рекомендацій):"),
            .interests
        ])

        viewDataSource?.sections = [mainDataSection, companyActivitySection, aboutCompacySection, socialSection, interestsSection]
    }


}

// MARK: - User cases
private extension CreateBusinessCardPresenter {

    func uploadCompanyAvatar(image: UIImage?) {
        guard let imageData = image?.jpegData(compressionQuality: Defaults.avatarImageCompressionQuality) else {
            Log.error("Cannot find selected image data!")
            return
        }

        view?.startLoading()
        APIClient.default.upload(imageData: imageData) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            switch result {
            case let .success(response):
                strongSelf.detailsModel.avatarImage = response
                strongSelf.view?.tableView.reloadData()
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func uploadCompanyBg(data: Data?) {
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
                strongSelf.detailsModel.backgroudImage = response
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

            self?.detailsModel.practices = practicies
            self?.detailsModel.interests = interests

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
        return detailsModel.practices.compactMap { $0.title }
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {
        guard let keyPath = keyPath as? WritableKeyPath<CreateBusinessCard.DetailsModel, String?> else {
            return
        }
        detailsModel[keyPath: keyPath] = text
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?) {
        guard let action = CreateBusinessCard.ActionType.init(rawValue: identifier ?? "") else {
            return
        }

        switch action {
        case .practice:
            break
        case .city:
            let filter = GMSAutocompleteFilter()
            filter.type = .city
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedCity) in
                if let id = fetchedCity.placeID {
                    cell.textField.text = fetchedCity.name
                    self?.detailsModel.city = PlaceModel(googlePlaceId: id, name: fetchedCity.name)
                }
            })
        case .region:
            let filter = GMSAutocompleteFilter()
            filter.type = .region
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedRegion) in
                if let id = fetchedRegion.placeID {
                    cell.textField.text = fetchedRegion.name
                    self?.detailsModel.city = PlaceModel(googlePlaceId: id, name: fetchedRegion.name)
                }
            })
        case .address:
            let filter = GMSAutocompleteFilter()
            filter.type = .address
            view?.showAutocompleteController(filter: filter, completion: { [weak self] (fetchedAddress) in
                if let id = fetchedAddress.placeID {
                    cell.textField.text = fetchedAddress.name
                    self?.detailsModel.city = PlaceModel(googlePlaceId: id, name: fetchedAddress.name)
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
        detailsModel[keyPath: keyPath] = text
    }


}

// MARK: - InterestsSelectionTableViewCellDataSource
extension CreateBusinessCardPresenter: InterestsSelectionTableViewCellDataSource {

    var interests: [InterestModel] {
        get {
            return detailsModel.interests
        }
        set {
            detailsModel.interests = newValue
        }
    }


}

// MARK: - SocialsListTableViewCellDelegate
extension CreateBusinessCardPresenter: SocialsListTableViewCellDelegate, SocialsListTableViewCellDataSource {

    var socials: [Social.ListItem] {
        get {
            return detailsModel.socials
        }
        set {
            detailsModel.socials = newValue
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


