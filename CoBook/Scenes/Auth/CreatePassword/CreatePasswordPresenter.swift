//
//  CreatePasswordPresenter.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: - View protocol
protocol CreatePasswordViewProtocol: class {

}

// MARK: - Presenter protocol
protocol CreatePasswordPresenterProtocol: class {
    var view: CreatePasswordViewProtocol? { get }
    var currentTelephoneNumberToShow: String { get }
    func set(view: CreatePasswordViewProtocol)
    func checkField(password: String?) -> Bool
}

// MARK: - ConfirmTelephoneNumberPresenter
class CreatePasswordPresenter: CreatePasswordPresenterProtocol {
    
    // MARK: Properties
    var view: CreatePasswordViewProtocol?
    private var password: String = ""

    var currentTelephoneNumberToShow: String {
        return "+38xxxxxxxxxx"
    }

    // MARK: Public
    func set(view: CreatePasswordViewProtocol) {
        self.view = view
    }

    func checkField(password: String?) -> Bool {
        self.password = password ?? ""
        return !self.password.isEmpty
    }
}
