//
//  CreateServicePresenter.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol CreateServiceView: class {
    func set(dataSource: DataSource<CreateServiceDataSourceConfigurator>?)
}

class CreateServicePresenter: NSObject, BasePresenter {

    /// Managed view
    weak var view: CreateServiceView?

    /// View data source
    private var dataSource: DataSource<CreateServiceDataSourceConfigurator>?

    // MARK: - Object Life Cycle

    override init() {
        super.init()

    }

    // MARK: - Public

    func attachView(_ view: CreateServiceView) {
        self.view = view
        view.set(dataSource: dataSource)
    }

    func detachView() {
        view = nil
    }


}

// MARK: - Updating View Data Source

private extension CreateServicePresenter {

    func updateViewDataSource() {

    }


}

// MARK: - Use cases

private extension CreateServicePresenter {

}
