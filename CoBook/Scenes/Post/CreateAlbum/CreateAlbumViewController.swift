//
//  CreateAlbumViewController.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CreateAlbumViewController: BaseViewController {

    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var deleteImageButton: DesignableButton!
    @IBOutlet var photoPlaceholderView: PhotosPlaceholderView!

    @Localized("Album.addPhotoButton.normalTitle")
    @IBOutlet var addImageButton: UIButton!

    @Localized("Button.save.normalTitle")
    @IBOutlet var saveButton: LoaderDesignableButton!

    @Localized("Album.name.placeholder")
    @IBOutlet var albumNameTextField: UITextField!

    /// picker that manage fetching images from gallery
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker(presentationController: self, allowsEditing: false)
        return imagePicker
    }()

    var presenter: CreateAlbumPresenter?

    // MARK: - Actions

    @IBAction func ablumTitleChanged(_ sender: UITextField) {
        presenter?.update(title: sender.text)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        presenter?.obSaveAlbumButtonTapped()
    }

    @IBAction func deleteImageButtonTapped(_ sender: Any) {
        presenter?.update(avatarID: nil)
        set(avatarPath: nil)
    }

    @IBAction func addImageButtonTapped(_ sender: Any) {
        imagePicker.onImagePicked = { [weak self] (image) in
            self?.presenter?.uploadAlbumAvatar(image: image)
        }

        imagePicker.present()
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        photoPlaceholderView.bringSubviewToFront(addImageButton)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.attachView(self)
        presenter?.setup()
    }

    deinit {
        presenter?.detachView()
    }


}

// MARK: - CreateAlbumView

extension CreateAlbumViewController: CreateAlbumView {

    func set(title: String?) {
        self.navigationItem.title = title
    }

    func set(avatarPath: String?) {
        guard let avatarPath = avatarPath, !avatarPath.isEmpty else {
            albumImageView.image = nil
            photoPlaceholderView.isHidden = false
            return
        }

        albumImageView?.setImage(withPath: avatarPath) { [weak self] (response) in
            switch response.result {
            case .success:
                self?.photoPlaceholderView.isHidden = true
            case .failure:
                self?.photoPlaceholderView.isHidden = false
            }
        }
    }

    func set(albumTitle: String?) {
        albumNameTextField.text = albumTitle
    }

    func setSaveButton(isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
    }


}
