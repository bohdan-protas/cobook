//
//  OnboardingViewController.swift
//  CoBook
//
//  Created by protas on 2/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, OnboardingView {

    // MARK: IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var progressView: DesignableProgressView!

    // MARK: Properties
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }()

    var dataManager: OnboardingDataManager = OnboardingDataManager()
    lazy var presenter: OnboardingPresenter = {
        let presenter = OnboardingPresenter(dataManager: dataManager)
        return presenter
    }()

    // MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = dataManager
        collectionView.register(OnboardingPageCollectionViewCell.nib, forCellWithReuseIdentifier: OnboardingPageCollectionViewCell.identifier)
        collectionView.collectionViewLayout = collectionViewLayout

        presenter.attachView(self)
        setupLayout()
    }

    deinit {
        presenter.detachView()
    }
    
    // MARK: - OnboardingView
    func goToSignUp() {
        self.performSegue(withIdentifier: SignUpNavigationController.segueId, sender: self)
    }

    func scrollToItem(at indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func page(for cell: UICollectionViewCell) -> Int? {
        return collectionView.indexPath(for: cell)?.item
    }


}

// MARK: - Privates
private extension OnboardingViewController {

    private func setupLayout() {
        let pageWidth = collectionView.frame.width
        let currentOffset = collectionView.contentOffset.x + pageWidth
        let fullOffset = CGFloat(dataManager.dataSource.count) * pageWidth
        let currentProgress: Float = Float(currentOffset / fullOffset)
        progressView.setProgress(currentProgress, animated: false)
    }


}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

}

// MARK: - ScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentOffset = scrollView.contentOffset.x + pageWidth
        let fullOffset = CGFloat(dataManager.dataSource.count) * pageWidth
        let currentProgress: Float = Float(currentOffset / fullOffset)
        progressView.setProgress(currentProgress, animated: true)
    }


}

