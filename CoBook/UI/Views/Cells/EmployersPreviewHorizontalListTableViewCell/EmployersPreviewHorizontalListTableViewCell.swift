//
//  EmployersPreviewHorizontalListTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol EmployersPreviewHorizontalListTableViewCellDataSource: class {
    var employers: [EmployeeModel] { get set }
}

protocol EmployersPreviewHorizontalListTableViewCellDelegate: class {
    func didLastEmployDeleted(_ cell: EmployersPreviewHorizontalListTableViewCell)
}

class EmployersPreviewHorizontalListTableViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!

    weak var dataSource: EmployersPreviewHorizontalListTableViewCellDataSource?
    weak var delegate: EmployersPreviewHorizontalListTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.register(EmployerPreviewHorizontalListItemCollectionViewCell.nib, forCellWithReuseIdentifier: EmployerPreviewHorizontalListItemCollectionViewCell.identifier)
        collectionView.contentInset = .init(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    
}

// MARK: - UICollectionViewDataSource
extension EmployersPreviewHorizontalListTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.employers.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmployerPreviewHorizontalListItemCollectionViewCell.identifier, for: indexPath) as! EmployerPreviewHorizontalListItemCollectionViewCell
        cell.delegate = self

        let employee = dataSource?.employers[safe: indexPath.row]
        cell.titleLabel.text = "\(employee?.firstName ?? "") \(employee?.lastName ?? "")"
        cell.professionLabel.text = employee?.practiceType?.title
        cell.telNumberLabel.text = employee?.telephone
        cell.avatarTextPlaceholderImageView.setTextPlaceholderImage(withPath: employee?.avatar,
                                                                    placeholderText: "\(employee?.firstName?.first?.uppercased() ?? "") \(employee?.lastName?.first?.uppercased() ?? "")")

        return cell
    }


}

// MARK: - UICollectionViewDelegateFlowLayout
extension EmployersPreviewHorizontalListTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: collectionView.frame.height)
    }

}

// MARK: - EmployerPreviewHorizontalListItemCollectionViewCellDelegate
extension EmployersPreviewHorizontalListTableViewCell: EmployerPreviewHorizontalListItemCollectionViewCellDelegate {

    func onDelete(_ cell: EmployerPreviewHorizontalListItemCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            collectionView.performBatchUpdates({
                dataSource?.employers.remove(at: indexPath.item)
                collectionView.deleteItems(at: [indexPath])
            }, completion: { finished in
                if self.dataSource?.employers.isEmpty ?? false {
                    self.delegate?.didLastEmployDeleted(self)
                }
            })
        }
    }


}


