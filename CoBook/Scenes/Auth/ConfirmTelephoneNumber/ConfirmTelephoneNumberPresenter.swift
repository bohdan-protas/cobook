//
//  ConfirmTelephoneNumberPresenter.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: - View protocol
protocol ConfirmTelephoneNumberViewProtocol: class {

}

// MARK: - Presenter protocol
protocol ConfirmTelephoneNumberPresenterProtocol: class {
    var view: ConfirmTelephoneNumberViewProtocol? { get set }

}

// MARK: - ConfirmTelephoneNumberPresenter
class ConfirmTelephoneNumberPresenter: ConfirmTelephoneNumberPresenterProtocol {
    var view: ConfirmTelephoneNumberViewProtocol?

    


}
