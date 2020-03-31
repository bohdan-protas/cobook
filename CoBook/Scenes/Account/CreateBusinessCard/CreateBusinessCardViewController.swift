//
//  CreateBusinessCardViewController.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces

class CreateBusinessCardViewController: BaseViewController {

    enum Defaults {
        static let estimatedRowHeight: CGFloat = 44
        static let footerHeight: CGFloat = 124
    }

    // MARK: Properties
    @IBOutlet var tableView: UITableView!

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
            //self?.presenter.createBusinessCard()
        }
        return view
    }()

    //var presenter = CreateBusinessCardPresenter()
    private var placeCompletion: ((GMSPlace) -> Void)?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

// MARK: Privates
private extension CreateBusinessCardViewController {

    func setupLayout() {
        self.navigationItem.title = "Створення бізнес візитки"

        tableView.estimatedRowHeight = Defaults.estimatedRowHeight
        tableView.delegate = self
    }


}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension CreateBusinessCardViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[.originalImage] as? UIImage else { return }
        //presenter.userImagePicked(image)
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
