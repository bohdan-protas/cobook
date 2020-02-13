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

    // MARK: Properties
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = collectionView.bounds.size

        return flowLayout
    }()

    private var dataSource: [Onboarding.ViewModel] = [
        Onboarding.ViewModel(title: "Title 01",
                             subtitle: "Опис особливостей додатку фічі, переваги, тощо",
                             image: UIImage(named: "ic_businessman"),
                             actionTitle: "Продовжити",
                             action: Onboarding.ButtonActionType.next),
        Onboarding.ViewModel(title: "Title 02",
                             subtitle: "Опис особливостей додатку фічі, переваги, тощо",
                             image: UIImage(named: "ic_business_plan"),
                             actionTitle: "Продовжити",
                             action: Onboarding.ButtonActionType.next),
        Onboarding.ViewModel(title: "Title 03",
                             subtitle: "Опис особливостей додатку фічі, переваги, тощо реваги, реваги, реваги, реваги, реваги, ",
                             image: UIImage(named: "ic_business_deal"),
                             actionTitle: "Розпочати",
                             action: Onboarding.ButtonActionType.finish)
    ]

    // MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(OnboardingPageCollectionViewCell.nib, forCellWithReuseIdentifier: OnboardingPageCollectionViewCell.identifier)
        collectionView.collectionViewLayout = collectionViewLayout

        setup()
    }

    private func setup() {
        let pageWidth = collectionView.frame.width
        let currentOffset = collectionView.contentOffset.x + pageWidth
        let fullOffset = CGFloat(self.dataSource.count) * pageWidth
        let currentProgress: Float = Float(currentOffset / fullOffset)
        progressView.setProgress(currentProgress, animated: false)
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
        cell.delegate = self
        return cell
    }


}

// MARK: - OnboardingPageCollectionViewCellDelegate
extension OnboardingViewController: OnboardingPageCollectionViewCellDelegate {

    func actionButtonDidTapped(_ cell: OnboardingPageCollectionViewCell, actionType: Onboarding.ButtonActionType?) {
        guard let action = actionType else {
            return
        }

        switch action {
        case .next:
            guard let currentPage = collectionView.indexPath(for: cell)?.item else {
                return
            }
            collectionView.scrollToItem(at: IndexPath(row: currentPage+1, section: 0), at: .centeredHorizontally, animated: true)
        case .finish:
            print("Navigation to register")
        }
    }

}

// MARK: - ScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentOffset = scrollView.contentOffset.x + pageWidth
        let fullOffset = CGFloat(self.dataSource.count) * pageWidth
        let currentProgress: Float = Float(currentOffset / fullOffset)
        progressView.setProgress(currentProgress, animated: true)
    }


}

