//
//  CreatePersonalCardViewController.swift
//  CoBook
//
//  Created by protas on 3/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces
import Kingfisher

class CreatePersonalCardViewController: BaseViewController, CreatePersonalCardView {

    enum Defaults {
        static let estimatedRowHeight: CGFloat = 44
        static let headerHeight: CGFloat = 120
        static let footerHeight: CGFloat = 124
        static let sectionHeaderHeight: CGFloat = 28
    }

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!
    var imagePicker = UIImagePickerController()

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

    private lazy var personalCardPhotoManagmentView: PersonalCardPhotoManagmentView = {
        let view = PersonalCardPhotoManagmentView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: Defaults.headerHeight)))
        view.delegate = self
        return view
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
        tableView.tableHeaderView = personalCardPhotoManagmentView
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

    func setImage(image: UIImage?) {
        personalCardPhotoManagmentView.setImage(image)
    }

    func setImage(image: URL?) {
        personalCardPhotoManagmentView.setImage(image)
    }

    func addNewSocial(name: String?, link: String?, completion: ((_ name: String?, _ url: String?) -> Void)? = nil) {
        let ac = UIAlertController(title: "Нова соціальна мережа", message: "Будь ласка, введіть назву та посилання", preferredStyle: .alert)

        let isEditing = !(name ?? "").isEmpty || !(link ?? "").isEmpty

        let submitAction = UIAlertAction(title: isEditing ? "Змінити": "Створити", style: .default) { [unowned ac] _ in
            let name = ac.textFields![safe: 0]?.text
            let url = ac.textFields?[safe: 1]?.text
            completion?(name, url)
        }
        submitAction.isEnabled = false
        let cancelAction = UIAlertAction(title: "Відмінити", style: .cancel, handler: nil)

        ac.addAction(submitAction)
        ac.addAction(cancelAction)

        ac.addTextField { (nameTextField) in
            nameTextField.text = name
            nameTextField.placeholder = "Назва"
        }
        ac.addTextField { (urlTextField) in
            urlTextField.text = link
            urlTextField.keyboardType = .URL
            urlTextField.placeholder = "Посилання, https://link.com"
        }

        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: ac.textFields?[safe: 1], queue: OperationQueue.main, using: { _ in
            let nameTextFieldTextCount = ac.textFields?[safe: 0]?.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            let urlTextFieldextCount = ac.textFields?[safe: 1]?.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            submitAction.isEnabled = (nameTextFieldTextCount > 0) && (urlTextFieldextCount > 0)
        })

        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: ac.textFields?[safe: 0], queue: OperationQueue.main, using: { _ in
            let nameTextFieldTextCount = ac.textFields?[safe: 0]?.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            let urlTextFieldextCount = ac.textFields?[safe: 1]?.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            submitAction.isEnabled = (nameTextFieldTextCount > 0) && (urlTextFieldextCount > 0)
        })

        present(controller: ac, animated: true)
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

// MARK: - PersonalCardPhotoManagmentViewDelegate
extension CreatePersonalCardViewController: PersonalCardPhotoManagmentViewDelegate {

    func cardPhotoManagmentViewDidAddPhoto(_ view: PersonalCardPhotoManagmentView) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            present(imagePickerController, animated: true, completion: nil)
        }
    }

    func cardPhotoManagmentViewDidChangePhoto(_ view: PersonalCardPhotoManagmentView) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            present(imagePickerController, animated: true, completion: nil)
        }
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
        return SectionHeaderSeparatorView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Defaults.sectionHeaderHeight
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
