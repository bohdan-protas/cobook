//
//  ChangePasswordPresenter.swift
//  CoBook
//
//  Created by protas on 5/20/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol ChangePasswordView: class, LoadDisplayableView, AlertDisplayableView, NavigableView {
    func set(dataSource: TableDataSource<ChangePasswordCellsConfigutator>?)
    func reload()
    func setSaveButtonEnabled(_ isEnabled: Bool)
    func setupSaveView()
}

class ChangePasswordPresenter: BasePresenter {

    // MARK: - Properties

    weak var view: ChangePasswordView?
    private var viewDataSource: TableDataSource<ChangePasswordCellsConfigutator>?

    var parametersModel: ChangePassword.Details {
        didSet {
            let isRequiredDataFilled = (
                !(parametersModel.oldPassword ?? "").trimmingCharacters(in: CharacterSet.whitespaces).isEmpty &&
                !(parametersModel.newPassword ?? "").trimmingCharacters(in: CharacterSet.whitespaces).isEmpty &&
                !(parametersModel.repeatPassword ?? "").trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
            )
            view?.setSaveButtonEnabled(isRequiredDataFilled)
            updateViewDataSource()
        }
    }
    
    // MARK: - Lifecycle

    init() {
        parametersModel = ChangePassword.Details(oldPassword: nil,
                                                 newPassword: nil,
                                                 repeatPassword: nil)

        viewDataSource = TableDataSource(sections: [], configurator: self.dataSourceConfigurator)
    }

    // MARK: - Public

    func attachView(_ view: ChangePasswordView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

    func setup() {
        view?.set(dataSource: viewDataSource)
        view?.setupSaveView()
        updateViewDataSource()
        view?.reload()
    }

    func chageCredentials() {
        guard parametersModel.newPassword == parametersModel.repeatPassword else {
            view?.infoAlert(title: "Settings.ChangePassword.passwordsDoNotMatch.title".localized,
                            message: "Settings.ChangePassword.passwordsDoNotMatch.message".localized)
            return
        }

        view?.startLoading()
        APIClient.default.changeCredentials(parameters: APIRequestParameters.Auth.Credentials(oldPassword: parametersModel.oldPassword, newPassword: parametersModel.newPassword)) { [weak self] (result) in
            switch result {
            case .success:
                self?.view?.stopLoading(success: true, completion: {
                    self?.view?.popController()
                })
            case .failure(let error):
                self?.view?.stopLoading(success: false, completion: {
                    self?.view?.infoAlert(title: nil, message: error.localizedDescription)
                })
            }
        }
    }


}

// MARK: - Privates

private extension ChangePasswordPresenter {

    func updateViewDataSource() {
        let infoSection = Section<ChangePassword.Cell>(items: [
            .title(text: "Settings.ChangePassword.section.oldPassword.title".localized),
            .textField(model: TextFieldModel(text: parametersModel.oldPassword, placeholder: "TextInput.placeholder.oldPassword".localized, associatedKeyPath: \ChangePassword.Details.oldPassword, keyboardType: .default)),

            .title(text: "Settings.ChangePassword.section.newPassword.title".localized),
            .textField(model: TextFieldModel(text: parametersModel.newPassword, placeholder: "TextInput.placeholder.newPassword".localized, associatedKeyPath: \ChangePassword.Details.newPassword, keyboardType: .default)),

            .title(text: "Settings.ChangePassword.section.repeareNewPassword.title".localized),
            .textField(model: TextFieldModel(text: parametersModel.repeatPassword, placeholder: "TextInput.placeholder.repeatPassword".localized, associatedKeyPath: \ChangePassword.Details.repeatPassword, keyboardType: .default)),
        ])

        viewDataSource?.sections = [infoSection]
    }


}

// MARK: - TextFieldTableViewCellDelegate

extension ChangePasswordPresenter: TextFieldTableViewCellDelegate {

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {
        guard let keyPath = keyPath as? WritableKeyPath<ChangePassword.Details, String?> else {
            return
        }
        parametersModel[keyPath: keyPath] = text
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?) {}


}

