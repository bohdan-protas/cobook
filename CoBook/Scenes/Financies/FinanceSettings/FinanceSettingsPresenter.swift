//
//  FinanceSettingsPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 29.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol FinanceSettingsView: class, LoadDisplayableView, AlertDisplayableView {
    func set(cooperationSummIncoms: Int)
    func set(exportedSumm: Int)
    func set(accountExpiredDaysCount: Int)
}

class FinanceSettingsPresenter: BasePresenter {
    
    weak var view: FinanceSettingsView?
    
    func attachView(_ view: FinanceSettingsView?) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func setup() {
        let currentDate = Date()
        let endDate = AppStorage.User.Profile?.franchiseEndDate ?? Date()
        let diffInDays = Calendar.current.dateComponents([.day], from: currentDate, to: endDate).day ?? 0
        
        view?.set(exportedSumm: 0)
        view?.set(cooperationSummIncoms: 0)
        view?.set(accountExpiredDaysCount: diffInDays)
    }
    
}
