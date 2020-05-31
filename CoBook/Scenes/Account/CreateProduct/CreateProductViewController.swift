//
//  CreateProductViewController.swift
//  CoBook
//
//  Created by protas on 4/28/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


fileprivate enum Layout {
    static let footerHeight: CGFloat = 124
}

class CreateProductViewController: BaseViewController, CreateProductView {

    @IBOutlet var tableView: UITableView!

    /// bottom save button
    private lazy var saveView: CardSaveView = {
        let view = CardSaveView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Layout.footerHeight)))
        view.saveButton.setTitle("Product.saveButton.normalTitle".localized, for: .normal)
        view.onSaveTapped = { [weak self] in
            self?.presenter?.createProduct()
        }
        return view
    }()

    /// bottom save button
    private lazy var updateView: CardSaveView = {
        let view = CardSaveView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Layout.footerHeight)))
        view.saveButton.setTitle("Product.updateButton.normalTitle".localized, for: .normal)
        view.onSaveTapped = { [weak self] in
            self?.presenter?.updateProduct()
        }
        return view
    }()

    /// picker that manage fetching images from gallery
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker(presentationController: self, allowsEditing: false)
        return imagePicker
    }()

    var presenter: CreateProductPresenter?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        presenter?.attachView(self)
        presenter?.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    deinit {
        presenter?.detachView()
    }

    // MARK: - Public

    func reload() {
        tableView.reloadData()
    }

    func set(dataSource: DataSource<CreateProductDataSourceConfigurator>?) {
        dataSource?.connect(to: tableView)
    }

    func setupSaveView() {
        tableView.tableFooterView = saveView
    }

    func setupUpdateView() {
        tableView.tableFooterView = updateView
    }

    func setSaveButtonEnabled(_ isEnabled: Bool) {
        saveView.saveButton.isEnabled = isEnabled
        updateView.saveButton.isEnabled = isEnabled
    }

    // MARK: - Navigation

}

// MARK: - Privates

private extension CreateProductViewController {

    func setupLayout() {
        self.navigationItem.title = "Product.create.title".localized
        tableView.delegate = self
    }


}

// MARK: - UITableViewDelegate

extension CreateProductViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }


}

// MARK: - HorizontalPhotosListDelegate

extension CreateProductViewController: HorizontalPhotosListDelegate {

    func didUpdatePhoto(_ cell: HorizontalPhotosListTableViewCell, at indexPath: IndexPath) {
        self.imagePicker.onImagePicked = { image in
            self.presenter?.uploadImage(image: image) { (imagePath, imageID) in
                cell.updateAt(indexPath: indexPath, with: .view(imagePath: imagePath, imageID: imageID))
            }
        }
        self.imagePicker.present()
    }

    func didDeletePhoto(_ cell: HorizontalPhotosListTableViewCell, at indexPath: IndexPath) {
        cell.deleteAt(indexPath: indexPath)
    }

    func didAddNewPhoto(_ cell: HorizontalPhotosListTableViewCell) {
        self.imagePicker.onImagePicked = { image in
            self.presenter?.uploadImage(image: image) { (imagePath, imageID) in
                cell.create(socialListItem: .view(imagePath: imagePath, imageID: imageID))
            }
        }
        self.imagePicker.present()
    }


}
