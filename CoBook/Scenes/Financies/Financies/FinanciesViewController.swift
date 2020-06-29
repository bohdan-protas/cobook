//
//  FinanciesViewController.swift
//  CoBook
//
//  Created by Bogdan Protas on 26.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class FinanciesViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
        
    var presenter = FinanciesPresenter()
    
    private lazy var headerInfoView: FinanceIncomsHeaderView = {
        let view = FinanceIncomsHeaderView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 244)))
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        presenter.attachView(self)
        presenter.setup()
    }
    
    // MARK - Action
    
    @objc func settingsAction() {
        goToFinanceSettings()
    }
    
    
}

// MARK: - FinanciesViewController

private extension FinanciesViewController {
    
    func setupLayout() {
        self.navigationItem.title = "Financies.title".localized
        self.tableView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_account_settings"), style: .plain, target: self, action: #selector(settingsAction))
    }
    
    
}

// MARK: - FinanciesView

extension FinanciesViewController: FinanciesView {
    
    func set(currentBalance: Int) {
        headerInfoView.currentBallanceValueLabel.text = "\(currentBalance)"
    }
    
    func set(minExportSumm: Int) {
        headerInfoView.maxSumForExportLabel.text = String(format: "Financies.header.mininumExportSum".localized, minExportSumm)
    }
    
    func set(exportedSumm: Int) {
        headerInfoView.averageSumOfExportsLabel.text = String(format: "Financies.header.exportedAverage".localized, exportedSumm)
    }
    
    func set(dataSource: TableDataSource<FinanciesCellsConfigurator>?) {
        dataSource?.connect(to: tableView)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func goToFinanceSettings() {
        let controller: FinanceSettingsViewController = UIStoryboard.financies.initiateViewControllerFromType()
        push(controller: controller, animated: true)
    }
    
    
}

// MARK: - UITableViewDelegate

extension FinanciesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerInfoView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return headerInfoView.frame.height
        }
        return 0
    }
    
    
}
 
