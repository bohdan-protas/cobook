//
//  CardsOverviewViewController.swift
//  CoBook
//
//  Created by protas on 4/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import CoreLocation

class CardsOverviewViewController: BaseViewController, CardsOverviewView {

    @IBOutlet var tableView: UITableView!

    var presenter: CardsOverviewViewPresenter = CardsOverviewViewPresenter()
    var dataSource: TableDataSource<CardsOverviewViewDataSourceConfigurator>?

    private lazy var itemsBarView: HorizontalItemsBarView = {
        let view = HorizontalItemsBarView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 58)), dataSource: presenter.barItems)
        view.delegate = self.presenter
        return view
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter.attachView(self)
        presenter.onViewDidLoad()
    }

    deinit {
        presenter.detachView()
    }

    // MARK: - CardsOverviewView

    func configureDataSource(with configurator: CardsOverviewViewDataSourceConfigurator) {
        dataSource = TableDataSource(tableView: self.tableView, configurator: configurator)
        tableView.dataSource = dataSource
    }

    func setup(sections: [Section<CardsOverview.Items>]) {
        dataSource?.sections = sections
        tableView.reloadData()
    }

    func reload(section: Section<CardsOverview.Items>, at index: Int) {
        tableView.beginUpdates()
        dataSource?.sections[index] = section
        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadSections(IndexSet(integer: index), with: .automatic)
        tableView.endUpdates()
    }


}

// MARK: - Privates
private extension CardsOverviewViewController {

    func setupLayout() {
        navigationItem.title = "Всі візитки"
        tableView.delegate = self


    }


}

// MARK: - UITableViewDelegate

extension CardsOverviewViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return itemsBarView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
             return itemsBarView.frame.height
        } else {
            return 0
        }
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.cellForRow(at: indexPath) as? MapTableViewCell
//        if cell == nil {
//            return UITableView.automaticDimension
//        } else {
//            return tableView.frame.size.height - 58
//        }
//    }



}


