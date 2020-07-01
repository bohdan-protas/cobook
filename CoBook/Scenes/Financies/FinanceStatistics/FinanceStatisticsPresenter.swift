//
//  FinanceStatisticsPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 30.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol FinanceStatisticsView: class {
    
}

class FinanceStatisticsPresenter: BasePresenter {
    
    weak var view: FinanceStatisticsView?
    
    // MARK: - Base presenter
    
    func attachView(_ view: FinanceStatisticsView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    
}
