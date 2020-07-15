//
//  FinanciesPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 26.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol FinanciesView: class, LoadDisplayableView, AlertDisplayableView {
    func set(dataSource: TableDataSource<FinanciesCellsConfigurator>?)
    func set(currentBalance: Int)
    func set(minExportSumm: Int)
    func set(exportedSumm: Int)
    func reload()
}

class FinanciesPresenter: BasePresenter {
    
    weak var view: FinanciesView?
    
    private var cardBonuseItems: [FinanceHistoryItemModel] = []
    private var userBallance: UserBallanceAPIModel?
    
    private var dataSource: TableDataSource<FinanciesCellsConfigurator>?
    private var configurator: FinanciesCellsConfigurator
    
    // MARK: - Lifecycle
    
    init() {
        let bonusHistoryItemCellConfigurator = TableCellConfigurator { (cell, model: FinanceHistoryItemModel, tableView, indexPath) -> CardPreviewTableViewCell in
            switch model.type {
            case .none:
                 cell.titleImageView.image = nil
                 cell.titleLabel.text = ""
            case .some(let value):
                switch value {
                case .personal:
                    let nameAbbr = "\(model.cardCreator?.firstName?.first?.uppercased() ?? "") \(model.cardCreator?.lastName?.first?.uppercased() ?? "")"
                    let textPlaceholderImage = nameAbbr.image(size: cell.titleImageView.frame.size)
                    cell.titleImageView.setImage(withPath: model.avatarURL, placeholderImage: textPlaceholderImage)
                    cell.titleLabel.text = "\(model.cardCreator?.firstName ?? "") \(model.cardCreator?.lastName ?? "")"
                case .business:
                    let textPlaceholderImage = (model.companyName ?? "").image(size: cell.titleImageView.frame.size)
                    cell.titleImageView.setImage(withPath: model.avatarURL, placeholderImage: textPlaceholderImage)
                    cell.titleLabel.text = model.companyName
                }
            }
            
            cell.proffesionLabel.text = model.practiceType
            cell.telephoneNumberLabel.text = model.telephone
            cell.detailLabel.isHidden = false
            cell.detailLabel.text = "+\(model.moneyIncome ?? 0)"
            return cell
        }
        self.configurator = FinanciesCellsConfigurator(bonusHistoryItemCellConfigurator: bonusHistoryItemCellConfigurator)
        self.dataSource = TableDataSource(sections: [], configurator: configurator)
    }
    
    // MARK: - Base presenter
    
    func attachView(_ view: FinanciesView) {
        self.view = view
        self.view?.set(dataSource: self.dataSource)
    }
    
    func detachView() {
        self.view = nil
    }
    
    // MARK: - Public
    
    func setup() {
        view?.startLoading(text: "Financies.loadingTitle".localized)
        let group = DispatchGroup()
        
        group.enter()
        APIClient.default.getCardBonusesStats { [weak self] (result) in
            guard let self = self else { return }
            
            self.view?.stopLoading()
            switch result {
            case .success(let response):
                let APICardBonuses = response ?? []
                self.cardBonuseItems = APICardBonuses.compactMap { FinanceHistoryItemModel(id: $0.id,
                                                                                           type: $0.type,
                                                                                           cardCreator: $0.cardCreator,
                                                                                           companyName: $0.company?.name,
                                                                                           avatarURL: $0.avatar?.sourceUrl,
                                                                                           practiceType: $0.practiceType?.title,
                                                                                           moneyIncome: $0.moneyIncome) }
                group.leave()
            case .failure(let error):
                group.leave()
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
        
        group.enter()
        APIClient.default.getUserBallace { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.userBallance = response
                group.leave()
            case .failure(let error):
                self.view?.errorAlert(message: error.localizedDescription)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.updateViewLayout()
            self.view?.reload()
        }
    }

    
}

// MARK: - Privates

private extension FinanciesPresenter {
    
    func updateViewLayout() {
        var bonuseItemsSection = Section<Financies.Item>(items: [])
        bonuseItemsSection.items = cardBonuseItems.compactMap { Financies.Item.bonusHistoryItem(model: $0) }
        dataSource?.sections = [bonuseItemsSection]
        
        view?.set(exportedSumm: Int(self.userBallance?.totalWithdraw ?? "") ?? 0)
        view?.set(currentBalance: self.userBallance?.totalIncome ?? 0)
        view?.set(minExportSumm: self.userBallance?.minWithdraw ?? 0)
    }
    
    
}
