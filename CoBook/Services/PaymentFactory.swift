//
//  PaymentFactory.swift
//  CoBook
//
//  Created by Bogdan Protas on 24.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import PortmoneSDKEcom


final class PaymentService {
    
    enum Pricing {
        static let businessCardInUSD: Double = 100
    }
    
    class func businessCardPayment(cardID: String, presentingView: UIViewController, delegate: PaymentPresenterDelegate) {
        let billNumb = "BC\(Int(Date().timeIntervalSince1970))"
        let flowType = PaymentFlowType(payWithCard: false, payWithApplePay: false, withoutCVV: false)
        let language = PortmoneSDKEcom.Language(rawValue: NSLocale.current.languageCode ?? "") ?? .english

        let params = PaymentParams(description: "Оплата бізнес візитки",
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
                                                styleSource: nil,
                                                language: language,
                                                biometricAuth: false,
                                                customUid: Constants.Payment.customUid)
        
        paymentPresenter.presentPaymentByCard(on: presentingView, params: params, showReceiptScreen: true)
    }
    
    
}
