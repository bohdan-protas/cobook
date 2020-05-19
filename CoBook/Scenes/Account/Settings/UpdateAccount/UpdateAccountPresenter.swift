//
//  UpdateAccountPresenter.swift
//  CoBook
//
//  Created by protas on 5/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol UpdateAccountView: class {

}

class UpdateAccountPresenter: BasePresenter {

    /// Managed view
    weak var view: UpdateAccountView?

    // MARK: - Public

    func attachView(_ view: UpdateAccountView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

}
