//
//  NotificationsListPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol NotificationsListView: class {
    func set(dataSource: TableDataSource<NotificationsListConfigurator>?)
}

class NotificationsListPresenter: BasePresenter {
    
    weak var view: NotificationsListView?
    private var dataSource: TableDataSource<NotificationsListConfigurator>?
    
    // MARK: - Initializators
    
    init() {
//        let cardHistoryPreviewCellConfigurator = TableCellConfigurator { (cell, model: LeaderboardStatAPIModel, tableView, indexPath) -> CardPreviewTableViewCell in
//            let nameAbbr = "\(model.firstName?.first?.uppercased() ?? "") \(model.lastName?.first?.uppercased() ?? "")"
//            let textPlaceholderImage = nameAbbr.image(size: cell.titleImageView.frame.size)
//            cell.titleImageView.setImage(withPath: model.avatar?.sourceUrl, placeholderImage: textPlaceholderImage)
//            cell.titleLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"
//            cell.detailLabel.isHidden = false
//            cell.detailLabel.text = "+\(model.score ?? 0)"
//            return cell
//        }
        let configurator = NotificationsListConfigurator()
        self.dataSource = TableDataSource(sections: [], configurator: configurator)
    }
    
    // MARK: - Base Presenter
    
    func attachView(_ view: NotificationsListView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    // MARK: - Public
    
    func setup() {
        
    }
    
}

// MARK: - Privates

private extension FinanceStatisticsPresenter {
    
    func updateViewLayout() {
//        view?.set(appDownloaderCount: self.numberOfAppDownloadingCount)
//        view?.set(businessAccountCreatedCount: self.numberOfBusinessAccountCreatingCount)
//
//        var cardRatingSection = Section<FinanceStatistics.Item>(accessoryIndex: FinanceStatistics.Section.rating.rawValue, items: [])
//        cardRatingSection.items = ratingCardItems.compactMap {
//            .ratingItem(model: $0)
//        }
//        dataSource?.sections = [cardRatingSection]
        
    }
    
    
}
