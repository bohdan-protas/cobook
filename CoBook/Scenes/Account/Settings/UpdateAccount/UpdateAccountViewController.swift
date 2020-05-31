//
//  UpdateAccountViewController.swift
//  CoBook
//
//  Created by protas on 5/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

fileprivate enum Layout {
    static let footerHeight: CGFloat = 124
}

class UpdateAccountViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    var presenter: UpdateAccountPresenter = UpdateAccountPresenter()

    /// save view
    lazy var saveView: CardSaveView = {
        let view = CardSaveView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Layout.footerHeight)))
        view.saveButton.setTitle("Button.save.normalTitle".localized, for: .normal)
        view.onSaveTapped = { [weak self] in
            self?.presenter.updateAccount()
        }
        return view
    }()

    /// picker for image fetching from camera and gallery
    lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker(presentationController: self, allowsEditing: true)
        return imagePicker
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings.UpdateAccount.title".localized

        presenter.attachView(self)
        presenter.setup()
    }

    deinit {
        presenter.detachView()
    }

}

// MARK: - UpdateAccountView

extension UpdateAccountViewController: UpdateAccountView {

    func set(dataSource: DataSource<UpdateAccountCellsConfigutator>?) {
        dataSource?.connect(to: tableView)
    }

    func reload() {
        tableView.reloadData()
    }

    func setupSaveCardView() {
        tableView.tableFooterView = saveView
    }

    func setSaveButtonEnabled(_ isEnabled: Bool) {
        saveView.saveButton.isEnabled = isEnabled
    }

    func didChangeAvatarPhoto(_ view: CardAvatarPhotoManagmentTableViewCell) {
        self.view.endEditing(true)
        imagePicker.cropViewControllerAspectRatioPreset = .presetSquare

        self.imagePicker.onImagePicked = { image in
            view.set(image: image)
            self.presenter.uploadAvatarImage(image: image)
        }

        self.imagePicker.present(dismissView: view.avatarImageView)
    }

    
}
