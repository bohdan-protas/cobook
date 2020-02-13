//
//  OnboardingViewController.swift
//  CoBook
//
//  Created by protas on 2/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var progressView: CustomProgressView!
    @IBOutlet var nextButton: UIButton!

    // MARK: Properties
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)

        return flowLayout
    }()

    private var dataSource: [Onboarding.ViewModel] = [
        Onboarding.ViewModel(title: "Title 01", subtitle: "Опис особливостей додатку фічі, переваги, тощо", image: UIImage(named: "ic_businessman")),
        Onboarding.ViewModel(title: "Title 02", subtitle: "Опис особливостей додатку фічі, переваги, тощо", image: UIImage(named: "ic_business_plan")),
        Onboarding.ViewModel(title: "Title 03", subtitle: "Опис особливостей додатку фічі, переваги, тощо реваги, реваги, реваги, реваги, реваги, ", image: UIImage(named: "ic_business_deal"))
    ]
    private var currentPage: Int = 0 {
        didSet {
            let title = currentPage == dataSource.count ? "Розпочати" : "Продовжити"
            nextButton.setTitle(title, for: .normal)
        }
    }

    // MARK: Actions
    @IBAction func onNextButtonTapped(_ sender: UIButton) {
        if currentPage == dataSource.count {
            // TODO: - Go to registration
            return
        }
        collectionView.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(OnboardingPageCollectionViewCell.nib, forCellWithReuseIdentifier: OnboardingPageCollectionViewCell.identifier)
        collectionView.collectionViewLayout = collectionViewLayout

        setup()
    }

    private func setup() {
        let width = self.view.frame.width
        let progress = Float(width / (width * CGFloat(dataSource.count)))

        currentPage = 0
        progressView.setProgress(progress, animated: false)
    }

}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingPageCollectionViewCell.identifier, for: indexPath) as! OnboardingPageCollectionViewCell
        cell.fill(dataSource[indexPath.row])
        return cell
    }


}

// MARK: - ScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentOffset = scrollView.contentOffset.x + pageWidth
        let fullOffset = CGFloat(self.dataSource.count) * pageWidth
        let currentProgress: Float = Float(currentOffset / fullOffset)

        currentPage = Int(currentOffset / pageWidth)
        progressView.setProgress(currentProgress, animated: true)
    }


}

