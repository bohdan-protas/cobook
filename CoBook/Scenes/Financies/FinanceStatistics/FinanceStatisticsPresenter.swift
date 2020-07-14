//
//  FinanceStatisticsPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 30.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol FinanceStatisticsView: class, AlertDisplayableView, LoadDisplayableView {
    func set(dataSource: TableDataSource<FinanceStatisticsConfigurator>?)
    func reload(section: FinanceStatistics.Section)
    func reload()
    func set(appDownloaderCount: Int)
    func set(businessAccountCreatedCount: Int)
}

class FinanceStatisticsPresenter: BasePresenter {
    
    weak var view: FinanceStatisticsView?
    
    private var ratingCardItems: [LeaderboardStatAPIModel] = []
    private var numberOfAppDownloadingCount: Int = 0
    private var numberOfBusinessAccountCreatingCount: Int = 0
    
    private var dataSource: TableDataSource<FinanceStatisticsConfigurator>?
    
    // MARK: - Lifecycle
    
    init() {
        let cardHistoryPreviewCellConfigurator = TableCellConfigurator { (cell, model: LeaderboardStatAPIModel, tableView, indexPath) -> CardPreviewTableViewCell in
            let nameAbbr = "\(model.firstName?.first?.uppercased() ?? "") \(model.lastName?.first?.uppercased() ?? "")"
            let textPlaceholderImage = nameAbbr.image(size: cell.titleImageView.frame.size)
            cell.titleImageView.setImage(withPath: model.avatar?.sourceUrl, placeholderImage: textPlaceholderImage)
            cell.titleLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"
            cell.detailLabel.isHidden = false
            cell.detailLabel.text = "+\(model.score ?? 0)"
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
        let group = DispatchGroup()
        var errors = [Error]()
        
        view?.startLoading(text: "Loading.loading.title".localized)
        
        group.enter()
        APIClient.default.getReferalStats { [weak self] (result) in
            switch result {
            case .success(let response):
                if let businessCountStr = response?.createdBusinessCardCount {
                    self?.numberOfBusinessAccountCreatingCount = Int(businessCountStr) ?? 0
                } else {
                    self?.numberOfBusinessAccountCreatingCount = 0
                }
                
                if let appDownloadCountStr = response?.downloadCount {
                    self?.numberOfAppDownloadingCount = Int(appDownloadCountStr) ?? 0
                } else {
                    self?.numberOfAppDownloadingCount = 0
                }
                group.leave()
            case .failure(let error):
                errors.append(error)
                group.leave()
            }
        }
        
        group.enter()
        let params = APIRequestParameters.Bonuses.LeaderbordStats(regionID: nil, limit: 50, offset: 0)
        APIClient.default.getBonusesRatings(params: params) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.ratingCardItems = response ?? []
                group.leave()
            case .failure(let error):
                errors.append(error)
                group.leave()
            }
        }
        
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.stopLoading()

            /// Errors handling
            if !errors.isEmpty {
                errors.forEach {
                    self.view?.errorAlert(message: $0.localizedDescription)
                }
            }
            
            self.updateViewLayout()
            self.view?.reload()
        }
        
    }
    
    func fetchInRegionRating() {
        self.view?.startLoading()
        let params = APIRequestParameters.Bonuses.LeaderbordStats(regionID: nil, limit: 50, offset: 0)
        APIClient.default.getBonusesRatings(params: params) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.stopLoading()
            switch result {
            case .success(let response):
                self.ratingCardItems = response ?? []
                self.updateViewLayout()
                self.view?.reload(section: .rating)
            case .failure(let error):
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func fetchAverageRating() {
        self.view?.startLoading()
        let params = APIRequestParameters.Bonuses.LeaderbordStats(regionID: nil, limit: 50, offset: 0)
        APIClient.default.getBonusesRatings(params: params) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.stopLoading()
            switch result {
            case .success(let response):
                self.ratingCardItems = response ?? []
                self.updateViewLayout()
                self.view?.reload(section: .rating)
            case .failure(let error):
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }
    
    
}

// MARK: - Privates

private extension FinanceStatisticsPresenter {
    
    func updateViewLayout() {
        view?.set(appDownloaderCount: self.numberOfAppDownloadingCount)
        view?.set(businessAccountCreatedCount: self.numberOfBusinessAccountCreatingCount)
        
        var cardRatingSection = Section<FinanceStatistics.Item>(accessoryIndex: FinanceStatistics.Section.rating.rawValue, items: [])
        cardRatingSection.items = ratingCardItems.compactMap {
            .ratingItem(model: $0)
        }
        dataSource?.sections = [cardRatingSection]
        
    }
    
    
}
