//
//  CreateArticlePresenter.swift
//  CoBook
//
//  Created by protas on 5/3/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


protocol CreateArticleView: class, LoadDisplayableView, AlertDisplayableView, NavigableView {
    func setContinueButton(actived: Bool)
    func set(title: String?)
    func set(articleTitle: String?)
    func set(acticleBody: String?)
    func set(albumTitle: String?, albumImage: String?)
    func reloadPhotos()
    func goToSelectAlbum(presenter: SelectAlbumPresenter)
}

protocol CreateArticlePresenterDelegate: class {
    func didFinishUpdating(_ presenter: CreateArticlePresenter)
}

class CreateArticlePresenter: BasePresenter {

    /// Managed view
    weak var view: CreateArticleView?
    weak var delegate: CreateArticlePresenterDelegate?

    /// Datasource
    private var cardID: Int
    private var parameters: CreateArticleModel {
        didSet {
            validateInput()
        }
    }
    private var isEditing: Bool

    var photos: [String] {
        get {
            parameters.photos.compactMap { $0.sourceUrl }
        }
    }

    // MARK: Object Life Cycle

    init(cardID: Int) {
        self.cardID = cardID
        self.parameters = CreateArticleModel(cardID: cardID)
        self.isEditing = false
    }

    init(parameters: CreateArticleModel) {
        self.cardID = parameters.cardID
        self.parameters = parameters
        self.isEditing = true
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
        isEditing ?
            view?.set(title: "Article.edit.title".localized) :
            view?.set(title: "Article.create.title".localized)
        
        view?.set(articleTitle: parameters.title)
        view?.set(acticleBody: parameters.body)
        view?.set(albumTitle: parameters.album?.title, albumImage: parameters.album?.avatarPath)
        view?.reloadPhotos()
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
        let presenter = SelectAlbumPresenter(cardID: self.cardID, selectedAlbumID: self.parameters.album?.albumID)
        presenter.delegate = self
        view?.goToSelectAlbum(presenter: presenter)
    }

    func uploadImage(image: UIImage?, completion: ((FileDataApiModel?) -> Void)?) {
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
                completion?(response)
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func onPublicButtonTapped() {
        if isEditing {
            updateArticle()
        } else {
            createArticle()
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

    func createArticle() {
        let parameters = CreateArticleApiModel(cardID: self.parameters.cardID,
                                               albumID: self.parameters.album?.albumID,
                                               title: self.parameters.title,
                                               body: self.parameters.body,
                                               photos: self.parameters.photos.compactMap { $0.id })

        view?.startLoading()
        APIClient.default.createArticle(parameters: parameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                strongSelf.view?.stopLoading(success: true, completion: {
                    strongSelf.delegate?.didFinishUpdating(strongSelf)
                    strongSelf.view?.popController()
                })
            case .failure(let error):
                strongSelf.view?.stopLoading(success: false, completion: {
                    strongSelf.view?.errorAlert(message: error.localizedDescription)
                })
            }
        }
    }

    func updateArticle() {
        let parameters = UpdateArticleApiModel(articleID: self.parameters.articleID,
                                               cardID: self.parameters.cardID,
                                               albumID: self.parameters.album?.albumID,
                                               title: self.parameters.title,
                                               body: self.parameters.body,
                                               photos: self.parameters.photos.compactMap { $0.id })

        view?.startLoading()
        APIClient.default.updateArticle(parameters: parameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                strongSelf.view?.stopLoading(success: true, completion: {
                    strongSelf.delegate?.didFinishUpdating(strongSelf)
                    strongSelf.view?.popController()
                })
            case .failure(let error):
                strongSelf.view?.stopLoading(success: false, completion: {
                    strongSelf.view?.errorAlert(message: error.localizedDescription)
                })
            }
        }
    }


}

// MARK: - SelectAlbumDelegate

extension CreateArticlePresenter: SelectAlbumDelegate {

    func selectedAlbum(_ model: PostPreview.Item.Model?) {
        parameters.album = model
        view?.set(albumTitle: parameters.album?.title, albumImage: parameters.album?.avatarPath)
    }


}





