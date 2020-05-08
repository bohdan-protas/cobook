//
//  CreateProductPresenter.swift
//  CoBook
//
//  Created by protas on 4/28/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol CreateProductView: AlertDisplayableView, HorizontalPhotosListDelegate, LoadDisplayableView, NavigableView {
    func reload()
    func set(dataSource: DataSource<CreateProductDataSourceConfigurator>?)
    func setupSaveView()
    func setupUpdateView()
    func setSaveButtonEnabled(_ isEnabled: Bool)
}

protocol CreateProductPresenterDelegate: class {
    func didUpdatedProduct(_ presenter: CreateProductPresenter)
}

class CreateProductPresenter: NSObject, BasePresenter {

    /// Managed view
    weak var view: CreateProductView?

    weak var delegate: CreateProductPresenterDelegate?

    /// data source
    private var dataSource: DataSource<CreateProductDataSourceConfigurator>?
    private var showRoomNumbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"]
    private var details: CreateProduct.DetailsModel {
        didSet {
            validateInput()
            updateViewDataSource()
        }
    }

    /// flag indicator for current state(editing&creating)
    fileprivate var isEditing: Bool

    // MARK: - Object Life Cycle

    init(detailsModel: CreateProduct.DetailsModel) {
        self.details = detailsModel
        self.isEditing = true
        super.init()
        setupDataSource()
    }

    init(businessCardID: Int, companyName: String?, companyAvatar: String?) {
        self.details = CreateProduct.DetailsModel(cardID: businessCardID, companyName: companyName, companyAvatar: companyAvatar)
        self.isEditing = false
        super.init()
        setupDataSource()
    }

    deinit {
        view = nil
    }

    // MARK: - Public

    func attachView(_ view: CreateProductView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    func onViewDidLoad() {
        updateViewDataSource()
        view?.set(dataSource: dataSource)
        isEditing ? view?.setupUpdateView() : view?.setupSaveView()
        view?.reload()
    }


}

// MARK: - Use cases

extension CreateProductPresenter {

    func createProduct() {
        /// api create  parameters
        let parameters = CreateProductApiModel(cardID: details.cardID,
                                               title: details.productName?.trimmingCharacters(in: .whitespaces),
                                               header: details.descriptionTitle?.trimmingCharacters(in: .whitespaces),
                                               description: details.desctiptionBody?.trimmingCharacters(in: .whitespaces),
                                               priceDetails: details.price?.trimmingCharacters(in: .whitespaces),
                                               contactTelephone: details.telephoneNumber?.trimmingCharacters(in: .whitespaces),
                                               contactEmail: details.email?.trimmingCharacters(in: .whitespaces),
                                               photosIds: details.photos.compactMap {
                                                switch $0 {
                                                case .view(_ ,let imageID):
                                                    return imageID
                                                default:
                                                    return nil
                                                }},
                                               showroom: Int(details.productShowRoom ?? ""))

        /// api create request
        view?.startLoading(text: "Створення...")
        APIClient.default.createProduct(with: parameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                strongSelf.view?.stopLoading(success: true, completion: {
                    strongSelf.delegate?.didUpdatedProduct(strongSelf)
                    AppStorage.State.isNeedToUpdateAccountData = true
                    strongSelf.view?.popController()

                })
            case .failure(let error):
                strongSelf.view?.stopLoading()
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func updateProduct() {
        /// Creating paramenters for api
        let parameters = UpdateProductApiModel(productID: details.productID,
                                               cardID: details.cardID,
                                               title: details.productName?.trimmingCharacters(in: .whitespaces),
                                               header: details.descriptionTitle?.trimmingCharacters(in: .whitespaces),
                                               description: details.desctiptionBody?.trimmingCharacters(in: .whitespaces),
                                               priceDetails: details.price?.trimmingCharacters(in: .whitespaces),
                                               contactTelephone: details.telephoneNumber?.trimmingCharacters(in: .whitespaces),
                                               contactEmail: details.email?.trimmingCharacters(in: .whitespaces),
                                               photosIds: details.photos.compactMap {
                                                switch $0 {
                                                case .view(_ ,let imageID):
                                                    return imageID
                                                default:
                                                    return nil
                                                }},
                                               showroom: Int(details.productShowRoom ?? ""))

        /// api update request
        view?.startLoading(text: "Оновлення...")
        APIClient.default.updateProduct(with: parameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                strongSelf.view?.stopLoading(success: true, completion: {
                    strongSelf.delegate?.didUpdatedProduct(strongSelf)
                    AppStorage.State.isNeedToUpdateAccountData = true
                    strongSelf.view?.popController()

                })
            case .failure(let error):
                strongSelf.view?.stopLoading()
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func uploadImage(image: UIImage?, completion: ((_ imagePath: String?, _ imageID: String?) -> Void)?) {
        guard let imageData = image?.jpegData(compressionQuality: 0.1) else {
            view?.errorAlert(message: "Помилка завантаження фото")
            return
        }

        view?.startLoading()
        APIClient.default.upload(imageData: imageData) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()
            switch result {
            case let .success(response):
                completion?(response?.sourceUrl, response?.id)
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

}

// MARK: - Privates

private extension CreateProductPresenter {

    func setupDataSource() {
        self.dataSource = DataSource(configurator: dataSouceConfigurator)
        self.dataSource?.sections = [Section<CreateProduct.Cell>(accessoryIndex: CreateProduct.SectionAccessoryIndex.header.rawValue, items: []),
                                     Section<CreateProduct.Cell>(accessoryIndex: CreateProduct.SectionAccessoryIndex.contacts.rawValue, items: []),
                                     Section<CreateProduct.Cell>(accessoryIndex: CreateProduct.SectionAccessoryIndex.description.rawValue, items: [])]
    }

    func validateInput() {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let isEnabled: Bool = {
            return
                !details.photos.isEmpty &&
                !(details.productName ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty &&
                !(details.productShowRoom ?? "").trimmingCharacters(in: .whitespaces).isEmpty &&
                (!(details.price ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty || details.isContractPrice) &&
                !(details.email ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty &&
                !(details.descriptionTitle ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty &&
                !(details.desctiptionBody ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty
        }()
        view?.setSaveButtonEnabled(isEnabled)
    }

    func updateViewDataSource() {
        // Header section
        dataSource?[Service.CreationSectionAccessoryIndex.header].items = [
            .companyHeader(model: CompanyPreviewHeaderModel(title: details.companyName, image: details.companyAvatar)),
            .gallery,
            .textField(model: TextFieldModel(text: details.productName, placeholder: "Назва товару", associatedKeyPath: \CreateProduct.DetailsModel.productName, keyboardType: .default)),
            .title(text: "Номер Show room:"),
            .actionField(model: ActionFieldModel(text: details.productShowRoom, placeholder: "Show room", actionTypeId: CreateProduct.ActionType.showroomNumber.rawValue)),
            .title(text: "Вартість послуги:"),
            .textField(model: TextFieldModel(isEnabled: !details.isContractPrice,
                                             text: details.price,
                                             placeholder: "Вкажіть вартість",
                                             associatedKeyPath: \CreateProduct.DetailsModel.price,
                                             keyboardType: .default)),
            .checkbox(model: CheckboxModel(title: "Ціна договірна", isSelected: details.isContractPrice, handler: { checkbox in
                checkbox.isSelected.toggle()
                self.details.isContractPrice = checkbox.isSelected
                if checkbox.isSelected {
                    self.details.price =  nil
                }
                self.view?.reload()
            })),
        ]

        // contacts section
        dataSource?[Service.CreationSectionAccessoryIndex.contacts].items = [
            .sectionSeparator,
            .title(text: "Контактні дані:"),
            .textField(model: TextFieldModel(isEnabled: !details.isUseContactsFromSite,
                                             text: details.telephoneNumber,
                                             placeholder: "Телефон для звязку",
                                             associatedKeyPath: \CreateProduct.DetailsModel.telephoneNumber,
                                             keyboardType: .phonePad)),

            .textField(model: TextFieldModel(isEnabled: !details.isUseContactsFromSite,
                                             text: details.email,
                                             placeholder: "Робочий емейл для звязку",
                                             associatedKeyPath: \CreateProduct.DetailsModel.email,
                                             keyboardType: .emailAddress)),
        ]
        if !isEditing {
            dataSource?[.contacts].items.append(
                .checkbox(model: CheckboxModel(title: "Використати контакти сторінки", isSelected: details.isUseContactsFromSite, handler: { checkbox in
                    checkbox.isSelected.toggle()
                    if checkbox.isSelected {
                        self.details.telephoneNumber = AppStorage.User.Profile?.telephone.number
                        self.details.email = AppStorage.User.Profile?.email.address
                    } else {
                        self.details.telephoneNumber = nil
                        self.details.email = nil
                    }
                    self.details.isUseContactsFromSite = checkbox.isSelected
                    self.view?.reload()
                }))
            )
        }

        // description section
        dataSource?[Service.CreationSectionAccessoryIndex.description].items = [
            .sectionSeparator,
            .textField(model: TextFieldModel(text: details.descriptionTitle, placeholder: "Заголовок товару", associatedKeyPath: \CreateProduct.DetailsModel.descriptionTitle, keyboardType: .default)),
            .textView(model: TextFieldModel(text: details.desctiptionBody, placeholder: "Опис товару", associatedKeyPath: \CreateProduct.DetailsModel.desctiptionBody, keyboardType: .default))
        ]

    }


}

// MARK: - TextFieldTableViewCellDataSource

extension CreateProductPresenter: TextFieldTableViewCellDataSource {

    var pickerList: [String] {
        return showRoomNumbers
    }


}

// MARK: - TextFieldTableViewCellDelegate

extension CreateProductPresenter: TextFieldTableViewCellDelegate {

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {
        guard let keyPath = keyPath as? WritableKeyPath<CreateProduct.DetailsModel, String?> else {
            return
        }
        details[keyPath: keyPath] = text
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?) {
        guard let action = CreateProduct.ActionType.init(rawValue: identifier ?? "") else {
            return
        }

        switch action {
        case .showroomNumber:
            details.productShowRoom = cell.textField.text
        }
    }


}

// MARK: - TextViewTableViewCellDelegate

extension CreateProductPresenter: TextViewTableViewCellDelegate {

    func textViewTableViewCell(_ cell: TextViewTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {
        guard let keyPath = keyPath as? WritableKeyPath<CreateProduct.DetailsModel, String?> else {
            return
        }
        details[keyPath: keyPath] = text
    }


}

// MARK: - HorizontalPhotosListDataSource

extension CreateProductPresenter: HorizontalPhotosListDataSource {

    var photos: [EditablePhotoListItem] {
        get {
            return details.photos
        }
        set {
            details.photos = newValue
        }
    }


}
