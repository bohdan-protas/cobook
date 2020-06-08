//
//  PhotoGalleryViewController.swift
//  CoBook
//
//  Created protas on 6/2/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class PhotoGalleryViewController: UIViewController {

    // MARK: Properties

    @IBOutlet var collectionView: UICollectionView!

    var photoItems: [String?] = []
    var currentPhotoIndex: Int = 0

    var viewDidLayoutSubviewsForTheFirstTime: Bool = true

    // MARK: Initializers

    init(photos: [String?], selectedPhotoIndex: Int? = nil) {
        self.photoItems = photos
        self.currentPhotoIndex = min(max(0, selectedPhotoIndex ?? 0), photoItems.count)
        super.init(nibName: "PhotoGalleryViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

	override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(PhotoGalleryItemCollectionViewCell.nib, forCellWithReuseIdentifier: PhotoGalleryItemCollectionViewCell.identifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.navigationItem.title = "Перегляд фото (\(currentPhotoIndex+1) з \(photoItems.count ))"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_nav_close"), style: .plain, target: self, action: #selector(closeAction))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewDidLayoutSubviewsForTheFirstTime {
            viewDidLayoutSubviewsForTheFirstTime = false
            self.collectionView.scrollToItem(at: IndexPath(item: currentPhotoIndex, section: 0), at: .left, animated: false)
        }
    }

    // MARK: Actions

    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - UICollectionViewDataSource

extension PhotoGalleryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGalleryItemCollectionViewCell.identifier, for: indexPath) as? PhotoGalleryItemCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.imageView.setImage(withPath: photoItems[indexPath.item])
        return cell
    }


}

// MARK: - UICollectionViewDataSource

extension PhotoGalleryViewController: UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPhotoIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        self.navigationItem.title = "Перегляд фото (\(currentPhotoIndex+1) з \(photoItems.count))"
    }


}

// MARK: - UICollectionViewDataSource

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width), height: collectionView.frame.size.width)
    }


}
