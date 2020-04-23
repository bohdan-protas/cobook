//
//  CreateServicePresenter.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol CreateServiceView: class, AlertDisplayableView {
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


}

// MARK: - Updating View Data Source

private extension CreateServicePresenter {

    func updateViewDataSource() {

        dataSource?[Service.CreationSectionAccessoryIndex.header].items = [
            .gallery
        ]

        dataSource?[Service.CreationSectionAccessoryIndex.contacts].items = [
            .sectionSeparator,
            .textField(model: TextFieldModel(text: nil, placeholder: "Назва послуги", associatedKeyPath: nil, keyboardType: .default)),
            .title(text: "Вартість послуги"),
            .textField(model: TextFieldModel(text: nil, placeholder: "Цифра і валюта", associatedKeyPath: nil, keyboardType: .default))
        ]

        dataSource?[Service.CreationSectionAccessoryIndex.description].items = [
            .sectionSeparator,
            .textField(model: TextFieldModel(text: nil, placeholder: "Назва послуги", associatedKeyPath: nil, keyboardType: .default)),
            .textView(model: TextFieldModel(text: nil, placeholder: "Опис послуги", associatedKeyPath: nil, keyboardType: .default))
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
