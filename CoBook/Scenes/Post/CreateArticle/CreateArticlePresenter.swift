//
//  CreateArticlePresenter.swift
//  CoBook
//
//  Created by protas on 5/3/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct CreateArticleModel {
    var cardID: Int
    var title: String?
    var body: String?
    var album: AlbumPreviewModel?
    var photos: [FileDataApiModel] = []
}

protocol CreateArticleView: LoadDisplayableView, AlertDisplayableView, NavigableView {
    func setContinueButton(actived: Bool)
    func set(title: String?)
    func set(body: String?)
    func set(albumTitle: String?, albumImage: String?)
    func goToSelectAlbum(presenter: SelectAlbumPresenter)
}

class CreateArticlePresenter: BasePresenter {

    /// Managed view
    weak var view: CreateArticleView?

    /// Datasource
    private var cardID: Int
    var photos: [String] {
        get {
            parameters.photos.compactMap { $0.sourceUrl }
        }
    }

    var parameters: CreateArticleModel {
        didSet {
            validateInput()
        }
    }

    // MARK: Object Life Cycle

    init(cardID: Int) {
        self.cardID = cardID
        self.parameters = CreateArticleModel(cardID: cardID)
    }

    deinit {
        detachView()
    }

    // MARK: - Base presenter

    func attachView(_ view: CreateArticleView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    // MARK: - Public

    func update(title: String?) {
        self.parameters.title = title
    }

    func update(body: String?) {
        self.parameters.body = body
    }

    func setup() {
        view?.set(title: parameters.title)
        view?.set(body: parameters.body)
        view?.set(albumTitle: parameters.album?.title, albumImage: parameters.album?.avatarPath)
        validateInput()
    }

    func addPhoto(data: FileDataApiModel?) {
        if let data = data {
            self.parameters.photos.append(data)
        }
    }

    func deletePhoto(at index: Int) {
        self.parameters.photos.remove(at: index)
    }

    func selectAlbumTapped() {
        let presenter = SelectAlbumPresenter(cardID: self.cardID, selectedAlbumID: self.parameters.album?.id)
        presenter.delegate = self
        view?.goToSelectAlbum(presenter: presenter)
    }

    func uploadImage(image: UIImage?, completion: ((FileDataApiModel?) -> Void)?) {
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
                completion?(response)
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func createArticle() {
        let parameters = CreateArticleApiModel(cardID: self.parameters.cardID,
                                               albumID: self.parameters.album?.id,
                                               title: self.parameters.title,
                                               body: self.parameters.body,
                                               photos: self.parameters.photos.compactMap { $0.id })

        view?.startLoading()
        APIClient.default.createArticle(parameters: parameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                strongSelf.view?.stopLoading(success: true, completion: {
                    strongSelf.view?.popController()
                })
                strongSelf.view?.popController()
            case .failure(let error):
                strongSelf.view?.stopLoading(success: false, completion: {
                    strongSelf.view?.errorAlert(message: error.localizedDescription)
                })
            }
        }
    }


}

// MARK: - Privates

private extension CreateArticlePresenter {

    func validateInput() {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let isEnabled: Bool = {
            return
                !(parameters.title ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty &&
                !(parameters.body ?? "").trimmingCharacters(in: whitespaceCharacterSet).isEmpty &&
                !(parameters.photos.isEmpty) &&
                !(parameters.album == nil)
        }()
        view?.setContinueButton(actived: isEnabled)
    }


}

// MARK: - SelectAlbumDelegate

extension CreateArticlePresenter: SelectAlbumDelegate {

    func selectedAlbum(_ model: AlbumPreviewModel?) {
        parameters.album = model
        view?.set(albumTitle: parameters.album?.title, albumImage: parameters.album?.avatarPath)
    }


}





