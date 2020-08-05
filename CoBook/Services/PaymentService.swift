//
//  PaymentFactory.swift
//  CoBook
//
//  Created by Bogdan Protas on 24.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import PortmoneSDKEcom


class PaymentService: StyleSourceModel {
            
    func businessCardPayment(cardID: String,
                             presentingView: UIViewController,
                             loadProgressView: LoadDisplayableView,
                             delegate: PaymentPresenterDelegate) {
        
        loadProgressView.startLoading()
        APIClient.default.getPricesInfo { [weak self] (result) in
            guard let self = self else { return }
            loadProgressView.stopLoading()
            
            switch result {
            case .success(let pricingInfo):
                
                guard let price = pricingInfo?.businessCard?.value else {
                    delegate.didFinishPayment(bill: nil, error: NSError.instantiate(code: -1, localizedMessage: "Pricing info is not defined"))
                    return
                }
                
                guard let currency = pricingInfo?.businessCard?.currency, let portmoneCurrency = Currency(rawValue: currency) else {
                    delegate.didFinishPayment(bill: nil, error: NSError.instantiate(code: -1, localizedMessage: "Pricing currency is not defined"))
                    return
                }
                
                let billNumb = "BC\(Int(Date().timeIntervalSince1970))"
                let flowType = PaymentFlowType(payWithCard: false, payWithApplePay: false, withoutCVV: false)
                let language = PortmoneSDKEcom.Language(rawValue: NSLocale.current.languageCode ?? "") ?? .english

                let params = PaymentParams(description: "Payment.description.businessCard".localized,
                                           attribute1: Constants.Payment.ContentType.card.rawValue,
                                           attribute2: AppStorage.User.Profile?.userId ?? "",
                                           attribute3: cardID,
                                           billNumber: billNumb,
                                           preauthFlag: false,
                                           billCurrency: portmoneCurrency,
                                           billAmount: price,
                                           billAmountWcvv: 0,
                                           payeeId: Constants.Payment.payeeID,
                                           type: .payment,
                                           paymentFlowType: flowType)


                let paymentPresenter = PaymentPresenter(delegate: delegate,
                                                        styleSource: self,
                                                        language: language,
                                                        biometricAuth: false,
                                                        customUid: Constants.Payment.customUid)

                paymentPresenter.presentPaymentByCard(on: presentingView, params: params, showReceiptScreen: true)
                
                
            case .failure(let error):
                delegate.didFinishPayment(bill: nil, error: error)
            }
        }
        

    }
    
    func franchisePayment(presentingView: UIViewController,
                          loadProgressView: LoadDisplayableView,
                          delegate: PaymentPresenterDelegate) {
        
        loadProgressView.startLoading()
        APIClient.default.getPricesInfo { [weak self] (result) in
            guard let self = self else { return }
            loadProgressView.stopLoading()
            
            switch result {
            case .success(let pricingInfo):
                
                guard let price = pricingInfo?.franchise?.value else {
                    delegate.didFinishPayment(bill: nil, error: NSError.instantiate(code: -1, localizedMessage: "Pricing info is not defined"))
                    return
                }
                
                guard let currency = pricingInfo?.franchise?.currency, let portmoneCurrency = Currency(rawValue: currency) else {
                    delegate.didFinishPayment(bill: nil, error: NSError.instantiate(code: -1, localizedMessage: "Pricing currency is not defined"))
                    return
                }
                
                let billNumb = "FR\(Int(Date().timeIntervalSince1970))"
                let flowType = PaymentFlowType(payWithCard: false, payWithApplePay: false, withoutCVV: false)
                let language = PortmoneSDKEcom.Language(rawValue: NSLocale.current.languageCode ?? "") ?? .english

                let params = PaymentParams(description: "Payment.description.franchise".localized,
                                           attribute1: Constants.Payment.ContentType.franchise.rawValue,
                                           attribute2: AppStorage.User.Profile?.userId ?? "",
                                           attribute3: "",
                                           billNumber: billNumb,
                                           preauthFlag: false,
                                           billCurrency: portmoneCurrency,
                                           billAmount: price,
                                           billAmountWcvv: 0,
                                           payeeId: Constants.Payment.payeeID,
                                           type: .payment,
                                           paymentFlowType: flowType)
                
                
                let paymentPresenter = PaymentPresenter(delegate: delegate,
                                                        styleSource: self,
                                                        language: language,
                                                        biometricAuth: false,
                                                        customUid: Constants.Payment.customUid)
                
                paymentPresenter.presentPaymentByCard(on: presentingView, params: params, showReceiptScreen: true)
                
            case .failure(let error):
                delegate.didFinishPayment(bill: nil, error: error)
            }
        }
        
        
    }
    
    // MARK: - StyleSourceModel
    
    override func titleFont() -> UIFont {
        return UIFont.SFProDisplay_Medium(size: 15)
    }
    
    override func titleColor() -> UIColor {
        return UIColor.Theme.blackMiddle
    }
    
    override func headersFont() -> UIFont {
        return UIFont.SFProDisplay_Regular(size: 14)
    }
    
    override func textsFont() -> UIFont {
        return UIFont.SFProDisplay_Regular(size: 14)
    }
    
    override func placeholdersFont() -> UIFont {
        return UIFont.SFProDisplay_Regular(size: 14)
    }
    
    override func buttonTitleFont() -> UIFont {
        return UIFont.SFProDisplay_Medium(size: 17)
    }
    
    override func buttonTitleColor() -> UIColor {
        return UIColor.Theme.blackMiddle
    }
    
    override func buttonColor() -> UIColor {
        return UIColor.Theme.accent
    }
    
    override func buttonCornerRadius() -> CGFloat {
        return 8
    }
    
    override func backgroundColor() -> UIColor {
        return UIColor.white
    }
    
    override func headersBackgroundColor() -> UIColor {
        return UIColor.Theme.grayBG
    }
    
}
