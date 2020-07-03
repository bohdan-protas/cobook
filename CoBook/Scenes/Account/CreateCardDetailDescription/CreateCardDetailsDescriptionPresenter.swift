//
//  CreateCardDetailsDescriptionPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 02.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol CreateCardDetailsDescriptionView: class, LoadDisplayableView, AlertDisplayableView {
    func reloadPhotos()
    func dismiss()
    func set(description: String?)
}

protocol CreateCardDetailsDescriptionDelegate: class {
    func onFinishEditing(description: String ,photosDataList: [FileDataApiModel])
}

class CreateCardDetailsDescriptionPresenter: BasePresenter {
    
    weak var view: CreateCardDetailsDescriptionView?
    
    private var description: String
    private var photosDataList: [FileDataApiModel]
    
    var photos: [String] {
        get {
            photosDataList.compactMap { $0.sourceUrl }
        }
    }
    
    weak var delegate: CreateCardDetailsDescriptionDelegate?

    // MARK: - Initializers
    
    init(photosDataList: [FileDataApiModel] = [], description: String = "") {
        self.description = description
        self.photosDataList = photosDataList
    }
    
    // MARK: - Base presenter
    
    func attachView(_ view: CreateCardDetailsDescriptionView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    // MARK: - Public
    
    func setup() {
        view?.set(description: description)
        view?.reloadPhotos()
    }
    
    func save() {
        let descriptionTrimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)
        delegate?.onFinishEditing(description: descriptionTrimmed, photosDataList: self.photosDataList)
        view?.dismiss()
    }
    
    func uploadImage(image: UIImage?, completion: ((FileDataApiModel?) -> Void)?) {
        guard let imageData = image?.jpegData(compressionQuality: 0.1) else {
            view?.errorAlert(message: "Error.photoLoading.message".localized)
            return
        }

        view?.startLoading()
        APIClient.default.upload(imageData: imageData) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.stopLoading()
            switch result {
            case let .success(response):
                completion?(response)
            case let .failure(error):
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func addPhoto(data: FileDataApiModel?) {
        if let data = data {
            self.photosDataList.append(data)
        }
    }

    func deletePhoto(at index: Int) {
        self.photosDataList.remove(at: index)
    }
    
    func update(description: String) {
        self.description = description
    }
    
    
}
