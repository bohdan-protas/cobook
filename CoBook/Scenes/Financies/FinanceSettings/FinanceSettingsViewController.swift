//
//  FinanceSettingsViewController.swift
//  CoBook
//
//  Created by Bogdan Protas on 29.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import PortmoneSDKEcom

class FinanceSettingsViewController: BaseViewController {

    @Localized("Financies.Settings.resultOfCooperation.title")
    @IBOutlet private var resultOfCooperationTitleLabel: UILabel!
    
    @Localized("Financies.Settings.resultOfCooperation.body")
    @IBOutlet private var resultOfCooperationBodyLabel: UILabel!
    
    @Localized("Financies.Settings.moneyIncomes.title")
    @IBOutlet private var moneyIncomeTitleLabel: UILabel!
    @IBOutlet private var moneyIncomeValueLabel: UILabel!
    
    @Localized("Financies.Settings.moneyExported.title")
    @IBOutlet private var moneyExportedTitleLabel: UILabel!
    @IBOutlet private var moneyExportedValueLabel: UILabel!
    
    @Localized("Financies.Settings.expiredFranchiseCount.title")
    @IBOutlet private var expiredDateTitleLabel: UILabel!
    @IBOutlet private var expiredDateValueLabel: UILabel!
    
    @Localized("Financies.Settings.continueCooperation.title")
    @IBOutlet private var continueCooperationButton: DesignableButton!
    
    @Localized("Financies.Settings.continueCooperation.hint")
    @IBOutlet private var continueCooperationDescriptionLabel: UILabel!
    
    @Localized("Financies.Settings.cancelCooperation.title")
    @IBOutlet private var cancelCooperationButton: UIButton!
    
    var presenter = FinanceSettingsPresenter()
    private let paymentService = PaymentService()
    private var pendingPaymentResult: (bill: Bill?, error: Error?)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.presenter.attachView(self)
        self.presenter.setup()
    }
    
    deinit {
        presenter.detachView()
    }
    
    // MARK: - Actions
    
    @IBAction func continueCooperationTapped(_ sender: Any) {
        paymentService.franchisePayment(presentingView: self, delegate: self)
        pendingPaymentResult = nil
    }
    
    @IBAction func cancelCooperationButton(_ sender: Any) {
        
    }
    
    
}

// MARK: - FinanceSettingsView

extension FinanceSettingsViewController: FinanceSettingsView {
    
    func set(cooperationSummIncoms: Int) {
        moneyIncomeValueLabel.text = "\(cooperationSummIncoms)"
    }
    
    func set(exportedSumm: Int) {
        moneyExportedValueLabel.text = "\(exportedSumm)"
    }
    
    func set(accountExpiredDaysCount: Int) {
        expiredDateValueLabel.text = String(format: "Financies.Settings.expiredFranchiseCount.value".localized, accountExpiredDaysCount)
    }
    
    
}

// MARK: - Privates

private extension FinanceSettingsViewController {
    
    func setupLayout() {
        self.navigationItem.title = "Financies.Settings.title".localized
    }
    
    
}

// MARK: - PaymentPresenterDelegate

extension FinanceSettingsViewController: PaymentPresenterDelegate {
    
    func dismissedSDK() {
        if let error = pendingPaymentResult?.error {
            self.errorAlert(message: error.localizedDescription)
        }
        
        if (pendingPaymentResult?.bill) != nil {
            self.infoAlert(title: "Payment.finishInfo.title".localized, message: "Payment.finishInfo.body".localized)
        }
        self.pendingPaymentResult = nil
    }
    
    func didFinishPayment(bill: Bill?, error: Error?) {
        pendingPaymentResult = (bill, error)
    }
    
    
}
