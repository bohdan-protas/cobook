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
    func set(title: String?)
}

class CreateAlbumPresenter: BasePresenter {

    // Managed view
    weak var view: CreateAlbumView?

    // Data source
    private var cardID: Int
    private var createParameters: CreateAlbumApiModel {
        didSet {
            validateInput()
        }
    }

    // MARK: - Object Life Cycle

    init(cardID: Int) {
        self.cardID = cardID
        self.createParameters = CreateAlbumApiModel(cardID: cardID)
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
        view?.set(title: nil)
        view?.set(avatarPath: nil)
        validateInput()
    }

    func update(title: String?) {
        createParameters.title = title
    }

    func update(avatarID: String?) {
        createParameters.avatarID = avatarID
    }

    func uploadAlbumAvatar(image: UIImage?) {
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
                strongSelf.update(avatarID: response?.id)
                strongSelf.view?.set(avatarPath: response?.sourceUrl)
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func createAlbum() {
        view?.startLoading()
        APIClient.default.createAlbum(parameters: createParameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.view?.stopLoading(success: true, completion: {
                    strongSelf.view?.popController()
                })
            case .failure(let error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

}

// MARK: - Privates

private extension CreateAlbumPresenter {

    func validateInput() {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let isEnabled: Bool = {
            return
                !(createParameters.avatarID ?? "").isEmpty &&
                !(createParameters.title ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty
        }()
        view?.setSaveButton(isEnabled: isEnabled)
    }


}
