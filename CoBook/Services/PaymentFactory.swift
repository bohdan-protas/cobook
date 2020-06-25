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
    
    enum Pricing {
        static let businessCardInUSD: Double = 100
    }
        
    func businessCardPayment(cardID: String, presentingView: UIViewController, delegate: PaymentPresenterDelegate) {
        let billNumb = "BC\(Int(Date().timeIntervalSince1970))"
        let flowType = PaymentFlowType(payWithCard: false, payWithApplePay: false, withoutCVV: false)
        let language = PortmoneSDKEcom.Language(rawValue: NSLocale.current.languageCode ?? "") ?? .english

        let params = PaymentParams(description: "Payment.description.businessCard".localized,
                                   attribute1: Constants.Payment.ContentType.card.rawValue,
                                   attribute2: AppStorage.User.Profile?.userId ?? "",
                                   attribute3: cardID,
                                   billNumber: billNumb,
                                   preauthFlag: false,
                                   billCurrency: .usd,
                                   billAmount: Pricing.businessCardInUSD,
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
    }
    
    // MARK: - StyleSourceModel
    
    override func titleFont() -> UIFont {
        return UIFont.SFProDisplay_Medium(size: 15)
    }
    
    override func titleColor() -> UIColor {
        return UIColor.Theme.blackMiddle
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
        return UIColor.Theme.grayBG
    }
    
}
