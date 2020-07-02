//
//  FinanceStatisticsPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 30.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol FinanceStatisticsView: class {
    func set(dataSource: TableDataSource<FinanceStatisticsConfigurator>?)
    func reload(section: FinanceStatistics.Section)
    func reload()
    func set(appDownloaderCount: Int)
    func set(businessAccountCreatedCount: Int)
}

class FinanceStatisticsPresenter: BasePresenter {
    
    weak var view: FinanceStatisticsView?
    
    private var averageRatingCardItems: [FinanceHistoryItemModel] = []
    private var inRegionRatingCardItems: [FinanceHistoryItemModel] = []
    private var numberOfAppDownloadingCount: Int = 0
    private var numberOfBusinessAccountCreatingCount: Int = 0
    
    private var dataSource: TableDataSource<FinanceStatisticsConfigurator>?
    
    // MARK: - Lifecycle
    
    init() {
        let cardHistoryPreviewCellConfigurator = TableCellConfigurator { (cell, model: FinanceHistoryItemModel, tableView, indexPath) -> CardPreviewTableViewCell in
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
        let configurator = FinanceStatisticsConfigurator(cardHistoryPreviewCellConfigurator: cardHistoryPreviewCellConfigurator)
        self.dataSource = TableDataSource(sections: [], configurator: configurator)
    }
    
    // MARK: - Base presenter
    
    func attachView(_ view: FinanceStatisticsView) {
        self.view = view
        self.view?.set(dataSource: dataSource)
    }
    
    func detachView() {
        self.view = nil
    }
    
    // MARK: - Public
    
    func setup() {
        updateViewLayout()
        view?.reload()
    }
    
    func fetchInRegion() {
        
    }
    
    func fetchAverageRating() {
        
    }
    
    
}

// MARK: - Privates

private extension FinanceStatisticsPresenter {
    
    func updateViewLayout() {
        view?.set(appDownloaderCount: self.numberOfAppDownloadingCount)
        view?.set(businessAccountCreatedCount: self.numberOfBusinessAccountCreatingCount)
        
        var cardRatingSection = Section<FinanceStatistics.Item>(accessoryIndex: FinanceStatistics.Section.rating.rawValue, items: [])
        cardRatingSection.items = []
        dataSource?.sections = [cardRatingSection]
        
    }
    
    
}
