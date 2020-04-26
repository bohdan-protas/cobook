//
//  CreateServicePresenter.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol CreateServiceView: AlertDisplayableView, HorizontalPhotosListDelegate, LoadDisplayableView {
    func reload()
    func set(dataSource: DataSource<CreateServiceDataSourceConfigurator>?)
    func setupSaveView()
    func setSaveButtonEnabled(_ isEnabled: Bool)
}

class CreateServicePresenter: NSObject, BasePresenter {

    /// Managed view
    weak var view: CreateServiceView?

    /// View data source
    private var dataSource: DataSource<CreateServiceDataSourceConfigurator>?

    private var details: Service.CreationDetailsModel {
        didSet {
            updateViewDataSource()
        }
    }

    // MARK: - Object Life Cycle

    override init() {
        self.details = Service.CreationDetailsModel()

        super.init()

        self.dataSource = DataSource(configurator: dataSouceConfigurator)
        self.dataSource?.sections = [Section<Service.CreationItem>(accessoryIndex: Service.CreationSectionAccessoryIndex.header.rawValue, items: []),
                                     Section<Service.CreationItem>(accessoryIndex: Service.CreationSectionAccessoryIndex.contacts.rawValue, items: []),
                                     Section<Service.CreationItem>(accessoryIndex: Service.CreationSectionAccessoryIndex.description.rawValue, items: [])]
    }

    // MARK: - Public

    func attachView(_ view: CreateServiceView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    func onViewDidLoad() {
        updateViewDataSource()
        view?.set(dataSource: dataSource)
        view?.setupSaveView()
        view?.reload()
    }

    func uploadImage(image: UIImage?, completion: ((_ imagePath: String?) -> Void)?) {
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
                completion?(response?.sourceUrl)
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}

// MARK: - Updating View Data Source

private extension CreateServicePresenter {

    func updateViewDataSource() {

        dataSource?[Service.CreationSectionAccessoryIndex.header].items = [
            .gallery,
            .textField(model: TextFieldModel(text: details.name, placeholder: "Назва послуги", associatedKeyPath: \Service.CreationDetailsModel.name, keyboardType: .default)),
            .title(text: "Вартість послуги:"),
            .textField(model: TextFieldModel(isEnabled: !details.isContractPrice,
                                             text: details.price,
                                             placeholder: "Вкажіть вартість",
                                             associatedKeyPath: \Service.CreationDetailsModel.price,
                                             keyboardType: .default)),
            .checkbox(CheckboxModel(title: "Ціна договірна", isSelected: details.isContractPrice, handler: { checkbox in
                checkbox.isSelected.toggle()
                self.details.isContractPrice = checkbox.isSelected
                if checkbox.isSelected {
                    self.details.price =  nil
                }
                self.view?.reload()
            })),
        ]

        dataSource?[Service.CreationSectionAccessoryIndex.contacts].items = [
            .sectionSeparator,
            .title(text: "Контактні дані:"),
            .textField(model: TextFieldModel(isEnabled: !details.isUseContactsFromSite,
                                             text: details.telephoneNumber,
                                             placeholder: "Телефон для звязку",
                                             associatedKeyPath: \Service.CreationDetailsModel.telephoneNumber,
                                             keyboardType: .phonePad)),

            .textField(model: TextFieldModel(isEnabled: !details.isUseContactsFromSite,
                                             text: details.email,
                                             placeholder: "Робочий емейл для звязку",
                                             associatedKeyPath: \Service.CreationDetailsModel.email,
                                             keyboardType: .emailAddress)),

            .checkbox(CheckboxModel(title: "Використати контакти сторінки", isSelected: details.isUseContactsFromSite, handler: { checkbox in
                checkbox.isSelected.toggle()
                if checkbox.isSelected {
                    self.details.telephoneNumber = nil
                    self.details.email = nil
                }
                self.details.isUseContactsFromSite = checkbox.isSelected
                self.view?.reload()
            })),
        ]

        dataSource?[Service.CreationSectionAccessoryIndex.description].items = [
            .sectionSeparator,
            .textField(model: TextFieldModel(text: details.descriptionTitle, placeholder: "Заголовок послуги", associatedKeyPath: \Service.CreationDetailsModel.descriptionTitle, keyboardType: .default)),
            .textView(model: TextFieldModel(text: details.desctiptionBody, placeholder: "Опис товару", associatedKeyPath: \Service.CreationDetailsModel.desctiptionBody, keyboardType: .default))
        ]

    }


}

// MARK: - Use cases

private extension CreateServicePresenter {

}

// MARK: - TextFieldTableViewCellDelegate

extension CreateServicePresenter: TextFieldTableViewCellDelegate {

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {
        guard let keyPath = keyPath as? WritableKeyPath<Service.CreationDetailsModel, String?> else {
            return
        }
        details[keyPath: keyPath] = text
    }


}

// MARK: - TextViewTableViewCellDelegate

extension CreateServicePresenter: TextViewTableViewCellDelegate {

    func textViewTableViewCell(_ cell: TextViewTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {
        guard let keyPath = keyPath as? WritableKeyPath<Service.CreationDetailsModel, String?> else {
            return
        }
        details[keyPath: keyPath] = text
    }


}

// MARK: - HorizontalPhotosListDataSource

extension CreateServicePresenter: HorizontalPhotosListDataSource {

    var photos: [EditablePhotoListItem] {
        get {
            return details.photos
        }
        set {
            details.photos = newValue
        }
    }


}


