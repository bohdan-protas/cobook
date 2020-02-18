//
//  SignUpPresenter.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: View -
protocol SignUpViewProtocol: class {

}

// MARK: Presenter -
protocol SignUpPresenterProtocol: class {
	var view: SignUpViewProtocol? { get set }
}

class SignUpPresenter: SignUpPresenterProtocol {

    weak var view: SignUpViewProtocol?
}
