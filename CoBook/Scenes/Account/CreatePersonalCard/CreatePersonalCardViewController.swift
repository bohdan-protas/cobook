//
//  CreatePersonalCardViewController.swift
//  CoBook
//
//  Created by protas on 3/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces

class CreatePersonalCardViewController: BaseViewController, CreatePersonalCardView {

    enum Defaults {
        static let estimatedRowHeight: CGFloat = 44
        static let footerHeight: CGFloat = 124
    }

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: Properties
    private var placeCompletion: ((GMSPlace) -> Void)?
    var presenter = CreatePersonalCardPresenter()

    private lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = false
        controller.sourceType = .photoLibrary
        controller.modalPresentationStyle = .overFullScreen
        return controller
    }()

    private lazy var cardSaveView: CardSaveView = {
        let view = CardSaveView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.footerHeight)))
        view.onSaveTapped = { [weak self] in
            self?.presenter.createPerconalCard()
        }
        return view
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter.attachView(self)
        presenter.onViewDidLoad()
    }

    func setupHeaderFooterViews() {
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

    func presentPickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }


}

// MARK: Privates
private extension CreatePersonalCardViewController {

    func setupLayout() {
        self.navigationItem.title = "Створення персональної візитки"

        tableView.estimatedRowHeight = Defaults.estimatedRowHeight
        tableView.delegate = self
    }


}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension CreatePersonalCardViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[.originalImage] as? UIImage else { return }
        presenter.userImagePicked(image)
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
