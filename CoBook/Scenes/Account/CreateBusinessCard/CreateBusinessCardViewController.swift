//
//  CreateBusinessCardViewController.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces

private enum Defaults {
    static let estimatedRowHeight: CGFloat = 44
    static let footerHeight: CGFloat = 124
}

class CreateBusinessCardViewController: BaseViewController, CreateBusinessCardView {

    // MARK: Properties
    @IBOutlet var tableView: UITableView!

    private lazy var imagePickerController: UIImagePickerController = {
         let controller = UIImagePickerController()
         controller.delegate = self
         controller.allowsEditing = true
         controller.sourceType = .photoLibrary
         controller.modalPresentationStyle = .overFullScreen
         return controller
     }()

    private lazy var cardSaveView: CardSaveView = {
        let view = CardSaveView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.footerHeight)))
        view.onSaveTapped = { [weak self] in
            self?.presenter.createBusinessCard()
        }
        return view
    }()


    var presenter = CreateBusinessCardPresenter()

    private var placeCompletion: ((GMSPlace) -> Void)?
    private var imagePickerCompletion: ((UIImage) -> Void)?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attachView(self)
        presenter.onViewDidLoad()
    }

    deinit {
        presenter.detachView()
    }

    // MARK: CreateBusinessCardView
    func setupLayout() {
        self.navigationItem.title = "Створення бізнес візитки"

        tableView.estimatedRowHeight = Defaults.estimatedRowHeight
        tableView.delegate = self
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
        autocompleteViewController.modalPresentationStyle = .overFullScreen
        autocompleteViewController.autocompleteFilter = filter
        autocompleteViewController.delegate = self

        present(autocompleteViewController, animated: true, completion: nil)
    }

    func showPickerController(completion: ((UIImage) -> Void)?) {
        view.endEditing(true)
        imagePickerCompletion = completion
        present(imagePickerController, animated: true, completion: nil)
    }

    func showSearchEmployersControlelr() {
        let searchNavigationController: SearchNavigationController = UIStoryboard.search.initiateViewControllerFromType()
        searchNavigationController.searchTableViewControllerDelegate = self
        self.present(searchNavigationController, animated: true, completion: nil)
    }


}

// MARK: Privates
private extension CreateBusinessCardViewController {

}

// MARK: - SearchTableViewControllerDelegate
extension CreateBusinessCardViewController: SearchTableViewControllerDelegate {

    func searchTableViewController(_ controller: SearchTableViewController, didSelected item: CardPreviewModel?) {
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

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension CreateBusinessCardViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[.editedImage] as? UIImage else { return }
        imagePickerCompletion?(image)
        imagePickerCompletion = nil
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
