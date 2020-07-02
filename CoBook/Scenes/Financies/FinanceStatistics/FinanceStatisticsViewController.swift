//
//  FinanceStatisticsViewController.swift
//  CoBook
//
//  Created by Bogdan Protas on 30.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class FinanceStatisticsViewController: BaseViewController {

    /// managed table view
    @IBOutlet weak var tableView: UITableView!
    
    /// switcherHeaderView
    private lazy var switcherHeaderView: SwitcherHeaderView = {
        let view = SwitcherHeaderView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 146)))
        view.firstActionButton.isSelected = true
        view.secondActionButton.isSelected = false
        view.firstActionHandler = { [weak self] in
            self?.presenter.fetchInRegionRating()
        }
        view.secondActionHandler = { [weak self] in
            self?.presenter.fetchAverageRating()
        }
        return view
    }()
    
    /// headerInfoView
    private lazy var headerInfoView: FinanceStatisticsHeaderView = {
        let view = FinanceStatisticsHeaderView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 143)))
        return view
    }()
    
    var presenter = FinanceStatisticsPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        presenter.attachView(self)
        presenter.setup()
    }
    
    
}

// MARK: - FinanceStatisticsViewController

private extension FinanceStatisticsViewController {
    
    func setupLayout() {
        navigationItem.title = "Finance.Statistics.title".localized
        tableView.delegate = self
        tableView.tableHeaderView = headerInfoView
    }
    
    
}

// MARK: - FinanceStatisticsView

extension FinanceStatisticsViewController: FinanceStatisticsView {
    
    func reload() {
        tableView.reloadData()
    }
    
    func set(appDownloaderCount: Int) {
        self.headerInfoView.appDownloadedValueLabel.text = String(format: "Finance.Statistics.appDownloaded.value".localized, appDownloaderCount)
    }
    
    func set(businessAccountCreatedCount: Int) {
        self.headerInfoView.businessAccountValueLabel.text = String(format: "Finance.Statistics.businessAccountCreated.value".localized, businessAccountCreatedCount)
    }
    
    func set(dataSource: TableDataSource<FinanceStatisticsConfigurator>?) {
        dataSource?.connect(to: tableView)
    }
    
    func reload(section: FinanceStatistics.Section) {
        tableView.beginUpdates()
        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadSections(IndexSet(integer: section.rawValue), with: .fade)
        tableView.endUpdates()
    }
    
    
}

// MARK: - UITableView delegate

extension FinanceStatisticsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let financeStatisticsSection = FinanceStatistics.Section(rawValue: section)
        switch financeStatisticsSection {
        case .none:
            return nil
        case .some(let section):
            switch section {
            case .rating:
                return switcherHeaderView
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let financeStatisticsSection = FinanceStatistics.Section(rawValue: section)
        switch financeStatisticsSection {
        case .none:
            return CGFloat.zero
        case .some(let section):
            switch section {
            case .rating:
                return switcherHeaderView.frame.height
            }
        }
    }
    
    
}
