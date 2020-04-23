//
//  CreateServiceViewController.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

fileprivate enum Layout {
    static let footerHeight: CGFloat = 124
}

class CreateServiceViewController: BaseViewController, CreateServiceView {

    @IBOutlet var tableView: UITableView!

    /// bottom save button
    private lazy var saveView: CardSaveView = {
        let view = CardSaveView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Layout.footerHeight)))
        view.saveButton.setTitle("Зберегти послугу", for: .normal)
        view.onSaveTapped = { [weak self] in
            
        }
        return view
    }()

    /// picker that manage fetching images from gallery
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker(presentationController: self, allowsEditing: false)
        return imagePicker
    }()

    var presenter = CreateServicePresenter()

    // MARK: ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        presenter.attachView(self)
        presenter.onViewDidLoad()
    }

    deinit {
        presenter.detachView()
    }

    // MARK: - CreateServiceView

    func set(dataSource: DataSource<CreateServiceDataSourceConfigurator>?) {
        dataSource?.connect(to: tableView)
    }

    func reload() {
        tableView.reloadData()
    }

    func setupSaveView() {
        tableView.tableFooterView = saveView
    }

    func setSaveButtonEnabled(_ isEnabled: Bool) {
        saveView.saveButton.isEnabled = isEnabled
    }


}

// MARK: - Privates

private extension CreateServiceViewController {

    func setupLayout() {
        self.navigationItem.title = "Послуга компанії"

        tableView.delegate = self
    }


}

// MARK: - UITableViewDelegate

extension CreateServiceViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }


}

// MARK: - HorizontalPhotosListDelegate

extension CreateServiceViewController: HorizontalPhotosListDelegate {

    func didAddNewPhoto(_ cell: HorizontalPhotosListTableViewCell) {
        self.view.endEditing(true)
        self.imagePicker.onImagePicked = { image in
            Log.debug("picked image")
        }
        self.imagePicker.present()
    }


}
