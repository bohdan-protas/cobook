//
//  CreatePersonalCardViewController.swift
//  CoBook
//
//  Created by protas on 3/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces

fileprivate enum Layout {
    static let estimatedRowHeight: CGFloat = 44
    static let footerHeight: CGFloat = 124
}

class CreatePersonalCardViewController: BaseViewController, CreatePersonalCardView {

    @IBOutlet var tableView: UITableView!

    private lazy var cardSaveView: CardSaveView = {
        let view = CardSaveView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Layout.footerHeight)))
        view.onSaveTapped = { [weak self] in
            self?.presenter.createPerconalCard()
        }
        return view
    }()

    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker(presentationController: self, allowsEditing: true)
        return imagePicker
    }()

    var presenter = CreatePersonalCardPresenter()
    private var placeCompletion: ((GMSPlace) -> Void)?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        presenter.attachView(self)
        presenter.onViewDidLoad()
    }

    // MARK: - CreatePersonalCardView

    func set(dataSource: TableDataSource<CreatePersonalCardDataSourceConfigurator>?) {
        tableView.dataSource = dataSource
    }

    func setupSaveCardView() {
        tableView.tableFooterView = cardSaveView
    }

    func showAutocompleteController(filter: GMSAutocompleteFilter, completion: ((GMSPlace) -> Void)?) {
        view.endEditing(true)
        placeCompletion = completion

        let autocompleteViewController = GMSAutocompleteViewController()
        autocompleteViewController.modalPresentationStyle = .overFullScreen
        autocompleteViewController.autocompleteFilter = filter
        autocompleteViewController.delegate = self

        present(autocompleteViewController, animated: true, completion: nil)
    }

    func setSaveButtonEnabled(_ isEnabled: Bool) {
        cardSaveView.saveButton.isEnabled = isEnabled
    }


}

// MARK: - Privates

private extension CreatePersonalCardViewController {

    func setupLayout() {
        self.navigationItem.title = "Створення персональної візитки"

        tableView.estimatedRowHeight = Layout.estimatedRowHeight
        tableView.delegate = self
    }


}

// MARK: - CardAvatarPhotoManagmentTableViewCellDelegate

extension CreatePersonalCardViewController: CardAvatarPhotoManagmentTableViewCellDelegate {

    func didChangeAvatarPhoto(_ view: CardAvatarPhotoManagmentTableViewCell) {
        self.view.endEditing(true)

        imagePicker.cropViewControllerAspectRatioPreset = .presetSquare

        self.imagePicker.onImagePicked = { image in
            view.set(image: image)
            self.presenter.uploadUserImage(image: image)
        }

        self.imagePicker.present(dismissView: view.avatarImageView)

    }


}

// MARK: - UITableViewDelegate

extension CreatePersonalCardViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }


}

// MARK: - GMSAutocompleteViewControllerDelegate

extension CreatePersonalCardViewController: GMSAutocompleteViewControllerDelegate {

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
