//
//  ChangePasswordViewController.swift
//  CoBook
//
//  Created by protas on 5/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

fileprivate enum Layout {
    static let footerHeight: CGFloat = 124
}

class ChangePasswordViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    var presenter: ChangePasswordPresenter = ChangePasswordPresenter()

    /// save view
    lazy var saveView: CardSaveView = {
        let view = CardSaveView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Layout.footerHeight)))
        view.saveButton.setTitle("Зберегти", for: .normal)
        view.onSaveTapped = { [weak self] in
            self?.presenter.chageCredentials()
        }
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Зміна паролю"
        presenter.attachView(self)
        presenter.setup()
    }
    
    deinit {
        presenter.detachView()
    }


}

// MARK: - ChangePasswordView

extension ChangePasswordViewController: ChangePasswordView {

    func set(dataSource: DataSource<ChangePasswordCellsConfigutator>?) {
        dataSource?.connect(to: tableView)
    }

    func reload() {
        tableView.reloadData()
    }

    func setSaveButtonEnabled(_ isEnabled: Bool) {
        saveView.saveButton.isEnabled = isEnabled
    }

    func setupSaveView() {
        tableView.tableFooterView = saveView
    }


}
