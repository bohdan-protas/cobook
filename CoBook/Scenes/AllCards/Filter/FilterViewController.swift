//
//  FilterViewController.swift
//  CoBook
//
//  Created by protas on 4/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

// MARK: - Defaults

fileprivate enum Defaults {
    static let headerHeight: CGFloat = 49
    static var footerHeight: CGFloat = 16
}

// MARK: - FilterViewControllerDelegate

protocol FilterViewControllerDelegate: class {
    func didFilterChanged(_ viewController: FilterViewController)
}

// MARK: - FilterViewController

class FilterViewController: BaseViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: LeftAlignedCollectionViewFlowLayout!

    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var presenter: FilterPresenter = FilterPresenter()
    weak var delegate: FilterViewControllerDelegate?

    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        presenter.save()
        self.dismiss(animated: true, completion: {
            self.delegate?.didFilterChanged(self)
        })
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        presenter.attachView(self)
        presenter.setup()
    }

    deinit {
        presenter.detachView()
    }


}

// MARK: - FilterView

extension FilterViewController: FilterView {

    func set(collectionDataSource: CollectionDataSource<FilterCellsConfigurator>?) {
        collectionDataSource?.connect(to: collectionView)
    }

    func showSearchPracticies(presenter: SearchPracticiesPresenter) {
        let searchViewController = SearchViewController(presenter: presenter)
        let navigation = CustomNavigationController(rootViewController: searchViewController)
        presentPanModal(navigation)
    }

    func reload() {
        collectionView.reloadData()
    }


}

// MARK: - TableViewDelegate

extension FilterViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            presenter.selectedItem(cell: cell, at: indexPath)
        }
    }


}

extension FilterViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return presenter.sizeForItemAt(indexPath: indexPath, for: collectionView.bounds)
    }


}

// MARK: - Privates

private extension FilterViewController {

    func setupLayout() {
        self.navigationItem.title = "Filter.title".localized
        collectionView.delegate = self
        saveBarButtonItem.setTitleTextAttributes([.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.greenDark], for: .normal)
    }


}
