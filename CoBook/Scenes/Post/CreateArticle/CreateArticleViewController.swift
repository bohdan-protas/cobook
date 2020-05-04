//
//  CreateArticleViewController.swift
//  CoBook
//
//  Created by protas on 4/30/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


class CreateArticleViewController: BaseViewController {

    @IBOutlet var photosCollectionView: UICollectionView!
    @IBOutlet var photosFlowLayout: UICollectionViewFlowLayout!

    @IBOutlet var headerTextField: UITextField!
    @IBOutlet var descriptionTextView: DesignableTextView!
    @IBOutlet var publicButton: LoaderDesignableButton!
    @IBOutlet var imageContainerView: UIView!

    /// picker that manage fetching images from gallery
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker(presentationController: self, allowsEditing: false)
        return imagePicker
    }()

    private lazy var photosPlacholderView: UIView = {
        return PhotosPlaceholderView(frame: photosCollectionView.frame)
    }()

    var presenter: CreateArticlePresenter?

    // MARK: - Actions
    
    @IBAction func publicButtonTapped(_ sender: Any) {

    }

    @IBAction func addPhotoTapped(_ sender: Any) {

        self.imagePicker.onImagePicked = { [weak self] image in

            self?.presenter?.uploadImage(image: image) { [weak self] (imagePath, imageID) in

                guard let item = self?.presenter?.photos.count else { return }

                self?.photosCollectionView.performBatchUpdates({
                    self?.presenter?.addPhoto(path: imagePath)
                    let indexPath = IndexPath(item: item, section: 0)
                    self?.photosCollectionView.insertItems(at: [indexPath])
                }, completion: { finished in
                    let indexPath = IndexPath(item: item, section: 0)
                    self?.photosCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
                    self?.photosCollectionView.backgroundView = nil
                })

            }
        }

        imagePicker.present()

    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter = CreateArticlePresenter(cardID: 0)
        presenter?.attachView(self)
        presenter?.onViewDidLoad()
    }

    deinit {
        presenter?.detachView()
    }


}

// MARK: - CreateArticleView

extension CreateArticleViewController: CreateArticleView {

    func set(title: String?) {
        self.headerTextField.text = title
    }

    func set(body: String?) {
        self.descriptionTextView.text = body
    }

    func setContinueButton(actived: Bool) {
        publicButton.isEnabled = actived
    }


}

// MARK: - Privates

private extension CreateArticleViewController {

    func setupLayout() {
        self.navigationItem.title = "Створити статтю"
        descriptionTextView.isScrollEnabled = false

        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.register(PostEditablePhotoCollectionViewCell.nib, forCellWithReuseIdentifier: PostEditablePhotoCollectionViewCell.identifier)

        photosCollectionView.backgroundView = photosPlacholderView
    }
    

}

// MARK: - UICollectionViewDataSource

extension CreateArticleViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostEditablePhotoCollectionViewCell.identifier, for: indexPath) as! PostEditablePhotoCollectionViewCell
        let model = presenter?.photos[indexPath.item]
        cell.photoImageView.setImage(withPath: model)
        cell.delegate = self
        return cell
    }


}

// MARK: - PostEditablePhotoCollectionViewCellDelegate

extension CreateArticleViewController: PostEditablePhotoCollectionViewCellDelegate {

    func delete(_ cell: PostEditablePhotoCollectionViewCell) {
        if let indexPath = photosCollectionView.indexPath(for: cell) {
            photosCollectionView.performBatchUpdates({
                self.presenter?.deletePhoto(at: indexPath.item)
                self.photosCollectionView.deleteItems(at: [indexPath])
                if self.presenter?.photos.isEmpty ?? true {
                    self.photosCollectionView.backgroundView = self.photosPlacholderView
                }
            }, completion: { (finished) in

            })
        }
    }


}

// MARK: - UICollectionViewDelegate

extension CreateArticleViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreateArticleViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.height)
    }


}








