//
//  ProductDetailsViewController.swift
//  CoBook
//
//  Created by protas on 4/29/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


private enum Defaults {
    static let editCardViewHeight: CGFloat = 84
}

class ProductDetailsViewController: BaseViewController, ProductDetailsView {

    @IBOutlet var tableView: UITableView!

    /// edit footer view
    private lazy var editCardFooterView: EditCardView = {
        let view = EditCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.editCardViewHeight)))
        view.editButton.setTitle("Product.editButton.normalTitle".localized, for: .normal)
        view.onEditTapped = { [weak self] in
            self?.presenter?.editProduct()
        }
        return view
    }()

    /// empty footer view
    private lazy var emptyFooterView: EditCardView = {
        let view = EditCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.editCardViewHeight)))
        view.editButton.isHidden = true
        return view
    }()

    var presenter: ProductDetailsPresenter?

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter?.attachView(self)
        presenter?.fetchProductDetails()
    }

    // MARK: - ServiceDetailsView

    func setupEmptyCardView() {
        tableView.tableFooterView = emptyFooterView
    }

    func setupEditCardView() {
        tableView.tableFooterView = editCardFooterView
    }

    func reload() {
        tableView.reloadData()
    }

    func set(dataSource: TableDataSource<ProductDetailsDataSourceConfigurator>?) {
        dataSource?.connect(to: tableView)
    }

    // MARK: - Navigation

    func goToEditProduct(_ presenter: CreateProductPresenter?) {
        let controller: CreateProductViewController = self.storyboard!.initiateViewControllerFromType()
        controller.presenter = presenter
        self.navigationController?.pushViewController(controller, animated: true)
    }


}

// MARK: - Privates

private extension ProductDetailsViewController {

    func setupLayout() {
        self.navigationItem.title = "Product.details.title".localized

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
    }


}

// MARK: - UITableViewDelegate

extension ProductDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
