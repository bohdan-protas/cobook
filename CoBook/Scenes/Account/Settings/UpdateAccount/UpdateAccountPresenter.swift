//
//  UpdateAccountPresenter.swift
//  CoBook
//
//  Created by protas on 5/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


protocol UpdateAccountView: LoadDisplayableView, AlertDisplayableView, NavigableView, CardAvatarPhotoManagmentTableViewCellDelegate {
    func set(dataSource: DataSource<UpdateAccountCellsConfigutator>?)
    func reload()
    func setSaveButtonEnabled(_ isEnabled: Bool)
    func setupSaveCardView()
}

fileprivate enum Defaults {
    static let imageCompressionQuality: CGFloat = 0.1
}

class UpdateAccountPresenter: BasePresenter {

    // MARK: - Properties

    /// Managed view
    weak var view: UpdateAccountView?
    private var viewDataSource: DataSource<UpdateAccountCellsConfigutator>?

    var parametersModel: UpdateAccount.Details {
        didSet {
            let isRequiredDataFilled = (
                !(parametersModel.firstName ?? "").trimmingCharacters(in: CharacterSet.whitespaces).isEmpty &&
                !(parametersModel.lastName ?? "").trimmingCharacters(in: CharacterSet.whitespaces).isEmpty &&
                !(parametersModel.email ?? "").trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
            )
            view?.setSaveButtonEnabled(isRequiredDataFilled)
            updateViewDataSource()
        }
    }

    // MARK: - Lifecycle

    init() {
        parametersModel = UpdateAccount.Details(
            firstName: AppStorage.User.Profile?.firstName,
            lastName: AppStorage.User.Profile?.lastName,
            avatar: AppStorage.User.Profile?.avatar,
            email: AppStorage.User.Profile?.email.address
        )
        viewDataSource = DataSource(sections: [], configurator: self.dataSourceConfigurator)
    }

    // MARK: - Public

    func attachView(_ view: UpdateAccountView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

    func setup() {
        view?.set(dataSource: viewDataSource)
        view?.setupSaveCardView()
        updateViewDataSource()
        view?.reload()
    }

    func uploadAvatarImage(image: UIImage?) {
        guard let imageData = image?.jpegData(compressionQuality: Defaults.imageCompressionQuality) else {
            view?.errorAlert(message: "Error.photoLoading.message".localized)
            return
        }

        view?.startLoading(text: "Loading.photoLoading.title".localized)
        APIClient.default.upload(imageData: imageData) { [weak self] (result) in
            self?.view?.stopLoading()
            switch result {
            case let .success(response):
                self?.parametersModel.avatar = response
                self?.updateViewDataSource()
            case let .failure(error):
                self?.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func updateAccount() {
        let params = APIRequestParameters.Profile.Update(firstName: parametersModel.firstName,
                                                         lastName: parametersModel.lastName,
                                                         avatarID: parametersModel.avatar?.id,
                                                         email: parametersModel.email == AppStorage.User.Profile?.email.address ? nil : parametersModel.email) // to prevent 409 server error not set not changed email

        view?.startLoading()
        APIClient.default.updateProfile(parameters: params) { [weak self] (result) in
            switch result {

            case .success:
                AppStorage.User.Profile?.firstName = self?.parametersModel.firstName
                AppStorage.User.Profile?.lastName = self?.parametersModel.lastName
                AppStorage.User.Profile?.avatar = self?.parametersModel.avatar
                AppStorage.User.Profile?.email.address = self?.parametersModel.email
                NotificationCenter.default.post(name: .profideDataUpdated, object: nil, userInfo: nil)

                self?.view?.stopLoading(success: true, completion: {
                    self?.view?.popController()
                })
            case .failure(let error):
                self?.view?.stopLoading(success: false, completion: {
                    self?.view?.errorAlert(message: error.localizedDescription)
                })
            }
        }
    }


}

// MARK: - Privates

private extension UpdateAccountPresenter {

    func updateViewDataSource() {
        let photosSection = Section<UpdateAccount.Cell>(items: [
            .avatarManagment(model: CardAvatarManagmentCellModel(sourceType: .account, imagePath: parametersModel.avatar?.sourceUrl, imageData: nil))
        ])

        let personalDataSection = Section<UpdateAccount.Cell>(items: [
            .sectionSeparator,
            .title(text: "Settings.UpdateAccount.section.firstName".localized),
            .textField(model: TextFieldModel(text: parametersModel.firstName, placeholder: "TextInput.placeholder.firstName" .localized, associatedKeyPath: \UpdateAccount.Details.firstName, keyboardType: .default)),

            .title(text: "Settings.UpdateAccount.section.lastName".localized),
            .textField(model: TextFieldModel(text: parametersModel.lastName, placeholder: "TextInput.placeholder.lastName".localized, associatedKeyPath: \UpdateAccount.Details.lastName, keyboardType: .default)),

            .title(text:"Settings.UpdateAccount.section.email".localized),
            .textField(model: TextFieldModel(text: parametersModel.email, placeholder: "TextInput.placeholder.email".localized, associatedKeyPath: \UpdateAccount.Details.email, keyboardType: .default)),
        ])

        viewDataSource?.sections = [photosSection, personalDataSection]
    }


}

// MARK: - TextFieldTableViewCellDelegate

extension UpdateAccountPresenter: TextFieldTableViewCellDelegate {

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didUpdatedText text: String?, forKeyPath keyPath: AnyKeyPath?) {
        guard let keyPath = keyPath as? WritableKeyPath<UpdateAccount.Details, String?> else {
            return
        }
        parametersModel[keyPath: keyPath] = text
    }

    func textFieldTableViewCell(_ cell: TextFieldTableViewCell, didOccuredAction identifier: String?) {}

}
