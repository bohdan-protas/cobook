//
//  OnboardingDataSource.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class OnboardingDataManager: NSObject, UICollectionViewDataSource {

    var dataSource: [Onboarding.PageModel] = []
    weak var delegate: OnboardingPageCollectionViewCellDelegate?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingPageCollectionViewCell.identifier, for: indexPath) as! OnboardingPageCollectionViewCell
        cell.fill(dataSource[indexPath.row])
        cell.delegate = delegate
        return cell
    }


}

