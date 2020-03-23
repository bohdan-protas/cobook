//
//  CreatePersonalCardHeaderView.swift
//  CoBook
//
//  Created by protas on 3/11/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import Kingfisher

protocol PersonalCardPhotoManagmentViewDelegate: class {
    func cardPhotoManagmentViewDidAddPhoto(_ view: PersonalCardPhotoManagmentView)
    func cardPhotoManagmentViewDidChangePhoto(_ view: PersonalCardPhotoManagmentView)
}

class PersonalCardPhotoManagmentView: BaseFromNibView {

    enum State: String {
        case addPhoto = "Додати фото"
        case changePhoto = "Змінити фото"
    }

    // MARK: Properties
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet var actionButton: UIButton!

    weak var delegate: PersonalCardPhotoManagmentViewDelegate?

    private var currentState: State = .addPhoto {
        didSet {
            actionButton.setTitle(currentState.rawValue, for: .normal)
        }
    }

    // MARK: Lifecycle
    override func setup() {
        currentState = .addPhoto
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
    }

    override func getNib() -> UINib {
        return PersonalCardPhotoManagmentView.nib
    }

    // MARK: Actions
    @IBAction func actionButtonTapped(_ sender: Any) {
        switch currentState {
        case .addPhoto:
            delegate?.cardPhotoManagmentViewDidAddPhoto(self)
        case .changePhoto:
            delegate?.cardPhotoManagmentViewDidChangePhoto(self)
        }
    }

    // MARK: Public
    func setImage(_ image: UIImage?) {
        if let newImage = image {
            imageView.image = newImage
            currentState = .changePhoto
        } else {
            imageView.image = UIImage(named: "ic_user")
            currentState = .addPhoto
        }
    }

    func setImage(_ image: URL?) {
        imageView.kf.setImage(with: image, placeholder: UIImage(named: "ic_user"))
        currentState = .changePhoto
    }


}
