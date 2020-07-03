//
//  CreateBusinessCardViewController.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces
import CropViewController

fileprivate enum Layout {
    static let estimatedRowHeight: CGFloat = 44
    static let footerHeight: CGFloat = 124
}

class CreateBusinessCardViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!

    private lazy var cardSaveView: CardSaveView = {
        let view = CardSaveView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Layout.footerHeight)))
        view.onSaveTapped = { [weak self] in
            self?.presenter.onCreationAction()
        }
        return view
    }()

    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker(presentationController: self, allowsEditing: true)
        return imagePicker
    }()

    var presenter = CreateBusinessCardPresenter()
    private var placeCompletion: ((GMSPlace) -> Void)?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        presenter.attachView(self)
        presenter.onViewDidLoad()
    }

    deinit {
        presenter.detachView()
    }


}

// MARK: - CreateBusinessCardView

extension CreateBusinessCardViewController: CreateBusinessCardView {

    func showSearchPracticies(presenter: SearchPracticiesPresenter) {
        let searchViewController = SearchViewController(presenter: presenter)
        let navigation = CustomNavigationController(rootViewController: searchViewController)
        presentPanModal(navigation)
    }
    
    func set(dataSource: TableDataSource<CreateBusinessCardDataSourceConfigurator>?) {
        dataSource?.connect(to: tableView)
    }

    func setupSaveCardView() {
        tableView.tableFooterView = cardSaveView
    }

    func setSaveButtonEnabled(_ isEnabled: Bool) {
        cardSaveView.saveButton.isEnabled = isEnabled
    }

    func showAutocompleteController(filter: GMSAutocompleteFilter, completion: ((GMSPlace) -> Void)?) {
        view.endEditing(true)
        placeCompletion = completion

        let autocompleteViewController = GMSAutocompleteViewController()
        autocompleteViewController.modalPresentationStyle = .currentContext
        autocompleteViewController.autocompleteFilter = filter
        autocompleteViewController.delegate = self

        presentPanModal(autocompleteViewController)
    }

    func showSearchEmployersControlelr() {
        let searchNavigationController: SearchNavigationController = UIStoryboard.search.initiateViewControllerFromType()
        searchNavigationController.searchTableViewControllerDelegate = self
        self.present(searchNavigationController, animated: true, completion: nil)
    }
    
    func showDescriptionCreationForm() {
        let controller: CreateCardDetailsDescriptionViewController = UIStoryboard.account.initiateViewControllerFromType()
        let navigation = CustomNavigationController(rootViewController: controller)
        self.presentPanModal(navigation)
    }


}

// MARK: - Privates

private extension CreateBusinessCardViewController {

    func setupLayout() {
        self.navigationItem.title = "BusinessCard.Creation.title".localized

        tableView.estimatedRowHeight = Layout.estimatedRowHeight
        tableView.delegate = self
    }
    

}

// MARK: - CardAvatarPhotoManagmentTableViewCellDelegate

extension CreateBusinessCardViewController: CardAvatarPhotoManagmentTableViewCellDelegate {

    func didChangeAvatarPhoto(_ view: CardAvatarPhotoManagmentTableViewCell) {
        self.view.endEditing(true)

        imagePicker.cropViewControllerAspectRatioPreset = .presetSquare

        self.imagePicker.onImagePicked = { image in
            view.set(image: image)
            self.presenter.uploadCompanyAvatar(image: image)
        }

        self.imagePicker.present(dismissView: view.avatarImageView)
    }


}

// MARK: - CardBackgroundManagmentTableViewCellDelegate

extension CreateBusinessCardViewController: CardBackgroundManagmentTableViewCellDelegate {

    func didChangeBackgroundPhoto(_ view: CardBackgroundManagmentTableViewCell) {
        self.view.endEditing(true)

        imagePicker.cropViewControllerAspectRatioPreset = .presetCustom
        imagePicker.cropViewControllerCustomAspectRatio = .init(width: 800, height: 260)

        self.imagePicker.onImagePicked = { image in
            view.set(image: image)
            self.presenter.uploadCompanyBg(image: image)
        }

        self.imagePicker.present(dismissView: view.bgImageView)
    }


}

// MARK: - SearchTableViewControllerDelegate

extension CreateBusinessCardViewController: SearchTableViewControllerDelegate {

    func searchTableViewController(_ controller: SearchTableViewController, didSelected item: EmployeeModel?) {
        presenter.addEmploy(model: item)
    }


}

// MARK: - UITableViewDelegate

extension CreateBusinessCardViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }


}

// MARK: - GMSAutocompleteViewControllerDelegate

extension CreateBusinessCardViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        placeCompletion?(place)
        placeCompletion = nil
        viewController.dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        debugPrint(error.localizedDescription)
        viewController.dismiss(animated: true, completion: { [weak self] in
            self?.errorAlert(message: error.localizedDescription)
        })
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }


}


