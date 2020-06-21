//
//  CardStatisticsPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 21.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


protocol CardStatisticsView: class, AlertDisplayableView, LoadDisplayableView {
    func set(dataSource: TableDataSource<CardStatisticsCellsConfigurator>?)
    func reload()
}

class CardStaticticsPresenter: BasePresenter {
    
    weak var view: CardStatisticsView?
    
    private var cardsStatistics: [CardStatisticInfoApiModel] = []
    private var dataSource: TableDataSource<CardStatisticsCellsConfigurator>?
    private var configurator: CardStatisticsCellsConfigurator
    
    init() {
        let sectionTitleConfigurator = TableCellConfigurator { (cell, model: CardStatisticInfoApiModel, tableView, indexPath) -> CardStatisticItemTableViewCell in
            cell.avatarImageView.setImage(withPath: model.avatar?.sourceUrl)
            switch model.cardType {
            case .none:
                cell.nameLabel.text = ""
            case .some(let cardType):
                switch cardType {
                case .personal:
                    cell.nameLabel.text = "\(model.cardCreator?.firstName ?? "") \(model.cardCreator?.lastName ?? "")"
                case .business:
                    cell.nameLabel.text = "\(model.company?.name ?? "")"
                }
            }
            cell.professionLabel.text = model.practiceType?.title
            cell.telephoneLabel.text = model.contactTelephone?.number
            cell.viewsCountValueLabel.text = model.cardViewsCount ?? "0"
            cell.savedCountValueLabel.text = model.savedCount ?? "0"
            cell.sharingCountValueLabel.text = "\(model.sharingCount ?? 0)"
            
            return cell
        }
        
        self.configurator = CardStatisticsCellsConfigurator(cardStatisticConfigurator: sectionTitleConfigurator)
    }
    
    func attachView(_ view: CardStatisticsView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func setup() {
        fetchStatistics()
    }
    
    func fetchStatistics() {
        view?.startLoading(text: "Оновлення статистики...")
        APIClient.default.cardStatisticsInfo { [weak self] (result) in
            guard let self = self else { return }
            self.view?.stopLoading()
            switch result {
            case .success(let response):
                self.cardsStatistics = response ?? []
                self.updateViewDataSource()
                self.view?.reload()
            case .failure(let error):
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func updateViewDataSource() {
        var cardHeaderSection = Section<CardStatistics.Item>(items: [])
        cardHeaderSection.items = cardsStatistics.compactMap { .card(model: $0) }
        dataSource?.sections = [cardHeaderSection]
    }
    
    
}
