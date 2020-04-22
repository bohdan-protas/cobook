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

class CreateServiceViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!

    /// bottom save button
    private lazy var cardSaveView: CardSaveView = {
        let view = CardSaveView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Layout.footerHeight)))
        view.onSaveTapped = { [weak self] in
            self?.presenter.createPerconalCard()
        }
        return view
    }()

    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker(presentationController: self, allowsEditing: false)
        return imagePicker
    }()

    var presenter = CreateServicePresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

// MARK: - Privates

private extension CreateServiceViewController {

    func setupLayout() {
        self.navigationItem.title = "Створення персональної візитки"

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
