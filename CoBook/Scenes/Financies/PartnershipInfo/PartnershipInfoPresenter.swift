//
//  PartnershipInfoPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 25.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum PartnershipInfo {
    case start
    case finish
}

protocol PartnershipInfoView: class {
    func set(title: String)
    func set(body: String)
    func set(actionTitle: String)
    func set(image: UIImage?)
    func francisePayment()
    func finishPayment()
}

class PartnershipInfoPresenter: BasePresenter {
    
    weak var view: PartnershipInfoView?
    private var type: PartnershipInfo
    
    init(type: PartnershipInfo) {
        self.type = type
    }
    
    func setup() {
        switch self.type {
        case .start:
            view?.set(image: UIImage.init(named: "ic_businessman"))
            view?.set(title: "Payment.startInfo.title".localized)
            view?.set(actionTitle: "Payment.startInfo.actionTitle".localized)
            view?.set(body: "Payment.startInfo.body".localized)
        case .finish:
            view?.set(image: UIImage.init(named: "ic_agreement"))
            view?.set(title: "Payment.finishInfo.title".localized)
            view?.set(actionTitle: "Payment.finishInfo.actionTitle".localized)
            view?.set(body: "Payment.finishInfo.body".localized)
        }
    }
    
    func attachView(_ view: PartnershipInfoView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func actionButton() {
        switch self.type {
        case .start:
            view?.francisePayment()
        case .finish:
            view?.finishPayment()
        }
    }
    
}
