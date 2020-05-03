//
//  CreateArticlePresenter.swift
//  CoBook
//
//  Created by protas on 5/3/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol CreateArticleView: LoadDisplayableView, AlertDisplayableView {
    func setContinueButton(actived: Bool)

    func set(title: String?)
    func set(body: String?)
}

class CreateArticlePresenter: BasePresenter {

    /// Managed view
    weak var view: CreateArticleView?

    /// Datasource
    private var cardID: Int
    private var albumID: Int?
    private var articleTitle: String?
    private var articleBody: String?

    var photos: [String?] = []

    // MARK: Object Life Cycle

    init(cardID: Int) {
        self.cardID = cardID
    }

    deinit {
        detachView()
    }

    // MARK: - Public

    func attachView(_ view: CreateArticleView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    func addPhoto(path: String?) {
        self.photos.append(path)
    }

    func deletePhoto(at index: Int) {
        self.photos.remove(at: index)
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





