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

    private var details: Service.CreationDetailsModel

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
            .textField(model: TextFieldModel(text: nil, placeholder: "Назва послуги", associatedKeyPath: nil, keyboardType: .default)),
            .title(text: "Вартість послуги:"),
            .textField(model: TextFieldModel(isEnabled: !details.isContractPrice,
                                             text: details.isContractPrice ? nil : nil,
                                             placeholder: details.isContractPrice ? "Ціна договірна" : "Вкажіть вартість",
                                             associatedKeyPath: nil,
                                             keyboardType: .default)),
            .checkbox(CheckboxModel(title: "Ціна договірна", isSelected: details.isContractPrice, handler: { checkbox in
                checkbox.isSelected.toggle()
                self.details.isContractPrice = checkbox.isSelected
                self.updateViewDataSource()
                self.view?.reload()
            })),
        ]

        dataSource?[Service.CreationSectionAccessoryIndex.contacts].items = [
            .sectionSeparator,
            .title(text: "Контактні дані:"),
            .textField(model: TextFieldModel(isEnabled: !details.isUseContactsFromSite,
                                             text: details.isUseContactsFromSite ? nil : nil,
                                             placeholder: "Телефон для звязку",
                                             associatedKeyPath: nil,
                                             keyboardType: .phonePad)),

            .textField(model: TextFieldModel(isEnabled: !details.isUseContactsFromSite,
                                             text: details.isUseContactsFromSite ? nil : nil,
                                             placeholder: "Робочий емейл для звязку",
                                             associatedKeyPath: nil,
                                             keyboardType: .emailAddress)),

            .checkbox(CheckboxModel(title: "Використати контакти сторінки", isSelected: details.isUseContactsFromSite, handler: { checkbox in
                checkbox.isSelected.toggle()
                self.details.isUseContactsFromSite = checkbox.isSelected
                self.updateViewDataSource()
                self.view?.reload()
            })),
        ]

        dataSource?[Service.CreationSectionAccessoryIndex.description].items = [
            .sectionSeparator,
            .textField(model: TextFieldModel(text: nil, placeholder: "Заголовок послуги", associatedKeyPath: nil, keyboardType: .default)),
            .textView(model: TextFieldModel(text: nil, placeholder: "Опис товару", associatedKeyPath: nil, keyboardType: .default))
        ]

    }


}

// MARK: - Use cases

private extension CreateServicePresenter {

}

// MARK: - TextFieldTableViewCellDelegate

extension CreateServicePresenter: TextFieldTableViewCellDelegate {

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {

    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?) {

    }


}

// MARK: - TextViewTableViewCellDelegate

extension CreateServicePresenter: TextViewTableViewCellDelegate {

    func textViewTableViewCell(_ cell: TextViewTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {

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


