//
//  CreatePersonalCardPresenter.swift
//  CoBook
//
//  Created by protas on 3/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol CreatePersonalCardView: AlertDisplayableView, LoadDisplayableView {

}

class CreatePersonalCardPresenter: BasePresenter {
    weak var view: CreatePersonalCardView?

    func attachView(_ view: CreatePersonalCardView) { self.view = view }
    func detachView() { view = nil }

    


}
