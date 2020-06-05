//
//  CreateAlbumPresenter.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol CreateAlbumView: LoadDisplayableView, AlertDisplayableView, NavigableView {
    func setSaveButton(isEnabled: Bool)
    func set(avatarPath: String?)
    func set(albumTitle: String?)
    func set(title: String?)
}

protocol CreateAlbumDelegate: class {
    func albumEdited(with parameters: CreateAlbumModel)
}

class CreateAlbumPresenter: BasePresenter {

    // Managed view
    weak var view: CreateAlbumView?
    weak var delegate: CreateAlbumDelegate?

    // Data source
    private var cardID: Int
    private var parameters: CreateAlbumModel {
        didSet {
            validateInput()
        }
    }

    private var isEditing: Bool

    // MARK: - Object Life Cycle

    init(cardID: Int) {
        self.cardID = cardID
        self.parameters = CreateAlbumModel(cardID: cardID)
        self.isEditing = false
    }

    init(parameters: CreateAlbumModel) {
        self.cardID = parameters.cardID
        self.parameters = parameters
        self.isEditing = true
    }

    // MARK: - Base Presenter

    func attachView(_ view: CreateAlbumView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

    // MARK: - Public

    func setup() {
        view?.set(title: isEditing ? "Album.editTitle".localized : "Album.createTitle".localized)
        view?.set(albumTitle: parameters.title)
        view?.set(avatarPath: parameters.avatarPath)
        validateInput()
    }

    func update(title: String?) {
        parameters.title = title
    }

    func update(avatarID: String?) {
        parameters.avatarID = avatarID
    }

    func uploadAlbumAvatar(image: UIImage?) {
        guard let imageData = image?.jpegData(compressionQuality: 0.1) else {
            view?.errorAlert(message: "Error.photoLoading.message".localized)
            return
        }

        view?.startLoading()
        APIClient.default.upload(imageData: imageData) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()
            switch result {
            case let .success(response):
                strongSelf.update(avatarID: response?.id)
                strongSelf.view?.set(avatarPath: response?.sourceUrl)
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func obSaveAlbumButtonTapped() {
        if isEditing {
            updateAlbum()
        } else {
            createAlbum()
        }
    }


}

// MARK: - Privates

private extension CreateAlbumPresenter {

    func validateInput() {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let isEnabled: Bool = {
            return
                !(parameters.avatarID ?? "").isEmpty &&
                !(parameters.title ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty
        }()
        view?.setSaveButton(isEnabled: isEnabled)
    }

    func createAlbum() {
        let createParameters = CreateAlbumApiModel(cardID: parameters.cardID, avatarID: parameters.avatarID, title: parameters.title)
        view?.startLoading()
        APIClient.default.createAlbum(parameters: createParameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()
            switch result {
            case .success:
                strongSelf.view?.popController()
            case .failure(let error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func updateAlbum() {
        let updateParameters = UpdateAlbumApiModel(albumID: parameters.albumID, title: parameters.title, avatarID: parameters.avatarID)
        view?.startLoading()
        APIClient.default.updateAlbum(parameters: updateParameters) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.stopLoading()
            switch result {
            case .success:
                self.delegate?.albumEdited(with: self.parameters)
                self.view?.popController()
            case .failure(let error):
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}
