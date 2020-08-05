//
//  PartnershipInfoViewController.swift
//  CoBook
//
//  Created by Bogdan Protas on 25.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import PortmoneSDKEcom

class PartnershipInfoViewController: BaseViewController {

    // MARK: - Properties
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var actionButton: DesignableButton!
    
    private let paymentService = PaymentService()
    private var pendingPaymentResult: (bill: Bill?, error: Error?)?
    
    var presenter: PartnershipInfoPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.attachView(self)
        presenter?.setup()
    }
    
    // MARK: - Actions
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        presenter?.actionButton()
        pendingPaymentResult = nil
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

// MARK: - PartnershipInfoView

extension PartnershipInfoViewController: PartnershipInfoView {
    
    func finishPayment() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(body: String) {
        bodyLabel.text = body
    }
    
    func set(actionTitle: String) {
        actionButton.setTitle(actionTitle, for: .normal)
    }
    
    func set(image: UIImage?) {
        titleImageView.image = image
    }
    
    func francisePayment() {
        paymentService.franchisePayment(presentingView: self, loadProgressView: self, delegate: self)
    }
    
    
}

// MARK: - PaymentPresenterDelegate

extension PartnershipInfoViewController: PaymentPresenterDelegate {
    
    func dismissedSDK() {
        if let error = pendingPaymentResult?.error {
            self.errorAlert(message: error.localizedDescription)
        }
        
        if let bill = pendingPaymentResult?.bill {
            
            Log.Firebase.franchisePurchase(billID: bill.billId, value: "\(bill.billAmount)")
            
            let presenter = PartnershipInfoPresenter(type: .finish)
            let controller: PartnershipInfoViewController = UIStoryboard.financies.initiateViewControllerFromType()
            controller.presenter = presenter
            self.navigationController?.pushViewController(controller, animated: true)
        }
        self.pendingPaymentResult = nil
    }
    
    func didFinishPayment(bill: Bill?, error: Error?) {
        pendingPaymentResult = (bill, error)
    }
    
    
}
