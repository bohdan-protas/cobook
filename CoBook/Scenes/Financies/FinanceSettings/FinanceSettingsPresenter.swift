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
    private var userBallance: UserBallanceAPIModel?
    
    func attachView(_ view: FinanceSettingsView?) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func setup() {
        view?.startLoading()
        APIClient.default.getUserBallace { [weak self] (result) in
            guard let self = self else { return }
            self.view?.stopLoading()
            
            switch result {
            case .success(let response):
                self.userBallance = response
                self.updateLayout()
            case .failure(let error):
                self.updateLayout()
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }

    }
    
}

// MARK: - Privates

private extension FinanceSettingsPresenter {
    
    func updateLayout() {
        let currentDate = Date()
        let endDate = AppStorage.User.Profile?.franchiseEndDate ?? Date()
        let diffInDays = Calendar.current.dateComponents([.day], from: currentDate, to: endDate).day ?? 0
        
        view?.set(exportedSumm: Int(self.userBallance?.totalWithdraw ?? "") ?? 0)
        view?.set(cooperationSummIncoms: self.userBallance?.totalIncome ?? 0)
        view?.set(accountExpiredDaysCount: diffInDays)
    }
    
}

