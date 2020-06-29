//
//  CardsOverviewPresenter.swift
//  CoBook
//
//  Created by protas on 4/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

protocol CardsOverviewView: AlertDisplayableView, LoadDisplayableView, NavigableView, CardItemTableViewCellDelegate, MapTableViewCellDelegate {
    var isSearchActived: Bool { get }
    func set(dataSource: TableDataSource<CardsOverviewViewDataSourceConfigurator>?)
    func reload(section: CardsOverview.SectionAccessoryIndex)
    func reload()
    func set(searchDataSource: TableDataSource<CardsOverviewViewDataSourceConfigurator>?)
    func reloadSearch(resultText: String)
    func goToBusinessCardDetails(presenter: BusinessCardDetailsPresenter?)
    func goToPersonalCardDetails(presenter: PersonalCardDetailsPresenter?)
    func goToArticleDetails(presenter: ArticleDetailsPresenter?)
    func showBottomLoaderView()
    func hideBottomLoaderView()
}

fileprivate enum Defaults {
    static let pageSize: UInt = 15
}

class CardsOverviewViewPresenter: NSObject, BasePresenter {

    /// managed view
    weak var view: CardsOverviewView?

    /// bar items busienss logic
    var barItems: [BarItem]
    var selectedBarItem: BarItem?

    private var dataSource: TableDataSource<CardsOverviewViewDataSourceConfigurator>?
    private var searchDataSource: TableDataSource<CardsOverviewViewDataSourceConfigurator>?

    /// cards data source
    private var searchCards: [CardItemViewModel] = []
    private var cards: [CardsOverview.BarSectionsTypeIndex: PaginationPage<CardItemViewModel>] = [:]
    private var albumPreviewSection: PostPreview.Section?

    /// Current pin request work item
    private var pendingCardMapMarkersRequestWorkItem: DispatchWorkItem?

    /// Current card search request work item
    private var pendingSearchResultWorkItem: DispatchWorkItem?

    private var isNewFolderSaving: Bool = false
    private var isInitialFetch: Bool = false

    // MARK: - BasePresenter

    override init() {
        self.barItems = [
            BarItem(index: CardsOverview.BarSectionsTypeIndex.allCards.rawValue, title: "BarItem.allCards".localized),
            BarItem(index: CardsOverview.BarSectionsTypeIndex.personalCards.rawValue, title: "BarItem.personalCards".localized),
            //BarItem(index: CardsOverview.BarSectionsTypeIndex.businessCards.rawValue, title: "BarItem.businessCards".localized),
            //BarItem(index: CardsOverview.BarSectionsTypeIndex.inMyRegionCards.rawValue, title: "BarItem.myRegion".localized),
        ].sorted { $0.index < $1.index }
        self.selectedBarItem = barItems.first
        super.init()

        // setup feed datasource
        dataSource = TableDataSource()
        dataSource?.sections = [Section<CardsOverview.Items>(accessoryIndex: CardsOverview.SectionAccessoryIndex.posts.rawValue, items: []),
                                Section<CardsOverview.Items>(accessoryIndex: CardsOverview.SectionAccessoryIndex.cards.rawValue, items: [])]
        dataSource?.configurator = dataSourceConfigurator

        // setup search datasource
        searchDataSource = TableDataSource(configurator: dataSourceConfigurator)
        searchDataSource?.sections = [Section<CardsOverview.Items>(accessoryIndex: CardsOverview.SectionAccessoryIndex.posts.rawValue, items: [])]
    }

    func attachView(_ view: CardsOverviewView) {
        self.view = view
        view.set(dataSource: dataSource)
        view.set(searchDataSource: searchDataSource)
    }

    func detachView() {
        view = nil
    }

    // MARK: - Public

    func setup(useLoader: Bool) {
        isInitialFetch = true
        if useLoader { view?.startLoading() }

        self.fetchArticles { [weak self] items in
            self?.albumPreviewSection = PostPreview.Section(dataSourceID: CardsOverview.postsDataSourceID, items: items.compactMap { PostPreview.Item.view($0) } )
            self?.fetchSelectedBarSectionData(useLoader: false)
        }
    }

    func selectedBarItemAt(index: Int) {
        self.selectedBarItem = barItems[safe: index]
        self.fetchSelectedBarSectionData(useLoader: true)
        self.view?.hideBottomLoaderView()
    }

    func selectedSearchCellAt(indexPath: IndexPath) {
        guard let item = searchDataSource?.sections[safe: indexPath.section]?.items[indexPath.item] else {
            return
        }
        goToItem(item)
    }

    func selectedCellAt(indexPath: IndexPath) {
        guard let item = dataSource?.sections[safe: indexPath.section]?.items[indexPath.item] else {
            return
        }
        goToItem(item)
    }

    func cellWillDisplayAt(indexPath: IndexPath) {
        switch selectedBarItem?.index {
        case .none: break
        case .some(let index):
            guard let currentBarIndex = CardsOverview.BarSectionsTypeIndex(rawValue: index) else {
                return
            }
            
            switch currentBarIndex {
            case .allCards:
                guard let cards = cards[.allCards] else {
                    return
                }
                if cards.items.count - 1 == indexPath.row && cards.isNeedToLoadNextPage && !cards.isFetching {
                    self.view?.showBottomLoaderView()
                    self.cards[.allCards]?.isFetching = true
                    fetchCards(type: nil, currentPaginationPage: cards) { [weak self] (cards) in
                        guard let self = self else { return }
                        self.cards[.allCards]?.append(items: cards)
                        self.cards[.allCards]?.isFetching = false
                        self.view?.hideBottomLoaderView()
                        self.update(section: .cards)
                    }
                }

            case .personalCards:
                guard let cards = cards[.personalCards] else {
                    return
                }

                if cards.items.count - 1 == indexPath.row && cards.isNeedToLoadNextPage && !cards.isFetching {
                    self.view?.showBottomLoaderView()
                    self.cards[.personalCards]?.isFetching = true
                    fetchCards(type: .personal, currentPaginationPage: self.cards[.personalCards]) { [weak self] (cards) in
                        guard let self = self else { return }
                        self.cards[.personalCards]?.append(items: cards)
                        self.view?.hideBottomLoaderView()
                        self.update(section: .cards)
                        self.cards[.personalCards]?.isFetching = false
                    }
                }

            case .businessCards:
                guard let cards = cards[.businessCards] else {
                    return
                }

                if cards.items.count - 1 == indexPath.row && cards.isNeedToLoadNextPage && !cards.isFetching {
                    self.view?.showBottomLoaderView()
                    self.cards[.businessCards]?.isFetching = true
                    fetchCards(type: .business, currentPaginationPage: self.cards[.businessCards]) { [weak self] (cards) in
                        guard let self = self else { return }
                        self.cards[.personalCards]?.append(items: cards)
                        self.view?.hideBottomLoaderView()
                        self.update(section: .cards)
                        self.cards[.businessCards]?.isFetching = false
                    }
                }

            default:
                break
            }
        }
    }

    func saveCardAt(indexPath: IndexPath, toFolder folderID: Int?, completion: ((_ success: Bool) -> Void)?) {
        var cardOwerviewItem: CardsOverview.Items?
        switch view?.isSearchActived {
        case .none: return
        case .some(let isSearching):
            switch isSearching {
            case true:
                cardOwerviewItem = searchDataSource?.sections[indexPath.section].items[indexPath.row]
            case false:
                cardOwerviewItem = dataSource?.sections[indexPath.section].items[indexPath.row]
            }
        }

        if let item = cardOwerviewItem {
            switch item {
            case .cardItem(let model):
                switch model.isSaved {
                case false:
                    saveCard(model, toFolder: folderID, completion: completion)
                case true:
                    unsaveCard(model, completion: completion)
                }
            default:
                break
            }
        }
    }

    func updateCardItem(id: Int, withSavedFlag flag: Bool) {
        if let index = cards[.allCards]?.items.firstIndex(where: { $0.id == id }) {
            cards[.allCards]?.items[index].isSaved = flag
        }

        if let index = cards[.personalCards]?.items.firstIndex(where: { $0.id == id }) {
            cards[.personalCards]?.items[index].isSaved = flag
        }

        if let index = cards[.businessCards]?.items.firstIndex(where: { $0.id == id }) {
            cards[.businessCards]?.items[index].isSaved = flag
        }

        if let index = searchCards.firstIndex(where: { $0.id == id }) {
            searchCards[index].isSaved = flag
        }

        updateViewDataSource()
    }


}

// MARK: - Data fetching

extension CardsOverviewViewPresenter {

    func fetchMapMarkersInRegionFittedBy(topLeft: CoordinateApiModel, bottomRight: CoordinateApiModel, completion: (([GMSMarker]) -> Void)?) {
        pendingCardMapMarkersRequestWorkItem?.cancel()
        pendingCardMapMarkersRequestWorkItem = DispatchWorkItem { [weak self] in
            APIClient.default.getCardLocationsInRegion(topLeftRectCoordinate: topLeft, bottomRightRectCoordinate: bottomRight) { [weak self] (result) in
                switch result {
                case .success(let response):
                    let markers: [GMSMarker] = (response ?? []).compactMap { apiModel in
                        if let latitide = apiModel.latitide, let longiture = apiModel.longiture {
                            let position = CLLocationCoordinate2D(latitude: latitide, longitude: longiture)
                            let marker = GMSMarker(position: position)
                            switch apiModel.type {
                                case .personal: marker.icon = UIImage(named: "ic_mapmarker_personal")
                                case .business: marker.icon = UIImage(named: "ic_mapmarker_business")
                            }
                            return marker
                        } else { return nil }
                    }
                    completion?(markers)
                case .failure(let error):
                    self?.view?.errorAlert(message: error.localizedDescription)
                }
            }
        }
        if pendingCardMapMarkersRequestWorkItem != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: pendingCardMapMarkersRequestWorkItem!)
        }
    }

    func fetchUserFolders(completion: (([FolderApiModel]) -> Void)?) {
        view?.startLoading()
        APIClient.default.getFolderList { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()
            switch result {
            case .success(let folders):
                completion?(folders ?? [])
            case .failure(let error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func createFolder(title: String, completion: ((BarItem) -> Void)?) {
        isNewFolderSaving = true
        self.view?.startLoading()
        APIClient.default.createFolder(title: title) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                if let id = response?.id {
                    let item = BarItem(index: id, title: title)
                    strongSelf.barItems.append(item)
                    completion?(item)
                }
            case .failure(let error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func fetchSearchResult(query: String) {
        pendingSearchResultWorkItem?.cancel()
        if query.isEmpty {
            searchDataSource?[.posts].items.removeAll()
            view?.reloadSearch(resultText: "CardOverview.search.emptySearch".localized)
            return
        }

        pendingSearchResultWorkItem = DispatchWorkItem { [weak self] in
            self?.fetchCards(searchQuery: query, type: nil, currentPaginationPage: nil) { [weak self] (searchCards) in
                self?.searchCards = searchCards
                self?.updateViewDataSource()
                self?.view?.reloadSearch(resultText: searchCards.isEmpty ?
                    "CardOverview.search.emptySearch".localized :
                    String(format: "CardOverview.search.cardSearchResult".localized, searchCards.count)
                )
            }
        }

        if pendingSearchResultWorkItem != nil, !(pendingSearchResultWorkItem?.isCancelled ?? true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: pendingSearchResultWorkItem!)
        }
    }


}

// MARK: - Privates

private extension CardsOverviewViewPresenter {

    func fetchSelectedBarSectionData(useLoader: Bool) {
        switch selectedBarItem?.index {
        case .none: break
        case .some(let index):
            guard let barIndex = CardsOverview.BarSectionsTypeIndex(rawValue: index) else {
                return
            }
            switch barIndex {
            case .allCards:
                if cards[.allCards]?.items.isEmpty ?? true || isInitialFetch {
                    if useLoader { view?.startLoading() }
                    fetchCards(type: nil, currentPaginationPage: cards[.allCards]) { [weak self] (cards) in
                        self?.cards[barIndex] = PaginationPage(pageSize: Defaults.pageSize, items: cards)
                        self?.reload(section: .cards)
                    }
                } else {
                    self.reload(section: .cards)
                }

            case .personalCards:
                if cards[.personalCards]?.items.isEmpty ?? true || isInitialFetch {
                    if useLoader { view?.startLoading() }
                    fetchCards(type: .personal, currentPaginationPage: cards[.personalCards]) { [unowned self] (cards) in
                        self.cards[barIndex] = PaginationPage(pageSize: Defaults.pageSize, items: cards)
                        self.reload(section: .cards)
                    }
                } else {
                    self.reload(section: .cards)
                }

            case .businessCards:
                if cards[.businessCards]?.items.isEmpty ?? true || isInitialFetch {
                    if useLoader { view?.startLoading() }
                    fetchCards(type: .business, currentPaginationPage: cards[.businessCards]) { [unowned self] (cards) in
                        self.cards[barIndex] = PaginationPage(pageSize: Defaults.pageSize, items: cards)
                        self.reload(section: .cards)
                    }
                } else {
                    self.reload(section: .cards)
                }

            case .inMyRegionCards:
                self.reload(section: .cards)
            }

        }
    }

    func fetchArticles(completion: (([PostPreview.Item.Model]) -> Void)?) {
        APIClient.default.getArticlesList(albumID: nil, limit: 50, offset: 0) { [weak self] (result) in
            switch result {
            case .success(let articles):
                let items = articles?.compactMap { PostPreview.Item.Model(albumID: $0.albumID,
                                                                          articleID: $0.id,
                                                                          title: $0.title,
                                                                          avatarPath: $0.avatar?.sourceUrl,
                                                                          avatarID: $0.avatar?.id) }
                completion?(items ?? [])
            case .failure(let error):
                completion?([])
                self?.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func fetchCards(searchQuery: String? = nil,
                    type: CardType?,
                    currentPaginationPage: PaginationPage<CardItemViewModel>?,
                    completion: (([CardItemViewModel]) -> Void)?) {
        
        let practiceTypeIds = AppStorage.User.Filters?.practicies.compactMap { $0.id }
        APIClient.default.getCardsList(type: type?.rawValue,
                                       practiseTypeIds: practiceTypeIds,
                                       search: searchQuery,
                                       limit: currentPaginationPage?.pageSize ?? Defaults.pageSize,
                                       offset: currentPaginationPage?.offset ?? 0) { [weak self] (result) in

            guard let strongSelf = self else { return }
            switch result {
            case let .success(response):
                let cards = response?.compactMap { CardItemViewModel(id: $0.id,
                                                                     type: $0.type,
                                                                     avatarPath: $0.avatar?.sourceUrl,
                                                                     firstName: $0.cardCreator?.firstName,
                                                                     lastName: $0.cardCreator?.lastName,
                                                                     companyName: $0.company?.name,
                                                                     profession: $0.practiceType?.title,
                                                                     telephoneNumber: $0.contactTelephone?.number,
                                                                     isSaved: $0.isSaved ?? false) } ?? []
                completion?(cards)
            case let .failure(error):
                completion?([])
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func saveCard(_ model: CardItemViewModel, toFolder folderID: Int?, completion: ((_ success: Bool) -> Void)?) {
        if !self.isNewFolderSaving { view?.startLoading() }
        isNewFolderSaving = false
        APIClient.default.addCardToFavourites(id: model.id, folderID: folderID) { [weak self] (result) in
            switch result {
            case .success:
                self?.updateCardItem(id: model.id, withSavedFlag: true)
                NotificationCenter.default.post(name: .cardSaved, object: nil, userInfo: [Notification.Key.cardID: model.id, Notification.Key.controllerID: CardsOverviewViewController.describing])
                completion?(true)
                self?.view?.stopLoading(success: true, succesText: "SavedContent.cardSaved.message".localized, failureText: nil, completion: nil)
            case .failure:
                completion?(false)
                self?.view?.stopLoading(success: false)
            }
        }
    }

    func unsaveCard(_ model: CardItemViewModel, completion: ((_ success: Bool) -> Void)?) {
        if !self.isNewFolderSaving { view?.startLoading() }
        isNewFolderSaving = false
        APIClient.default.deleteCardFromFavourites(id: model.id) { [weak self] (result) in
            switch result {
            case .success:
                self?.updateCardItem(id: model.id, withSavedFlag: false)
                NotificationCenter.default.post(name: .cardSaved, object: nil, userInfo: [Notification.Key.cardID: model.id, Notification.Key.controllerID: CardsOverviewViewController.describing])
                completion?(true)
                self?.view?.stopLoading(success: true, succesText: "SavedContent.cardUnsaved.message".localized, failureText: nil, completion: nil)
            case .failure:
                completion?(false)
                self?.view?.stopLoading(success: false)
            }
        }
    }

    func updateViewDataSource() {
        // Posts section
        
        if albumPreviewSection?.items.isEmpty ?? true {
            dataSource?[CardsOverview.SectionAccessoryIndex.posts].items = []
        } else {
            dataSource?[CardsOverview.SectionAccessoryIndex.posts].items = [
                .postPreview(model: albumPreviewSection)
            ]
        }
        // Cards section
        let barItemIndex = CardsOverview.BarSectionsTypeIndex(rawValue: selectedBarItem?.index ?? -1)
        switch barItemIndex {
        case .none: break
        case .some(let index):
            switch index {
                case .allCards, .personalCards, .businessCards:
                    let cardsToShow = cards[index]?.items ?? []
                    dataSource?[.cards].items = cardsToShow.compactMap { .cardItem(model: $0) }
                case .inMyRegionCards:
                    dataSource?[.cards].items = [.map]
            }
        }

        // Search cards
        searchDataSource?[.posts].items = searchCards.map { .cardItem(model: $0) }
    }

    func update(section: CardsOverview.SectionAccessoryIndex) {
        self.view?.stopLoading()
        self.updateViewDataSource()
        self.isInitialFetch = false
        self.view?.reload()
    }

    func reload(section: CardsOverview.SectionAccessoryIndex) {
        self.view?.stopLoading()
        self.updateViewDataSource()
        if self.isInitialFetch {
            self.view?.reload()
            self.isInitialFetch = false
        } else {
            self.view?.reload(section: section)
        }
    }

    func goToItem(_ item: CardsOverview.Items) {
        switch item {
        case .cardItem(let model):
            switch model.type {

            case .personal:
                let presenter = PersonalCardDetailsPresenter(id: model.id)
                view?.goToPersonalCardDetails(presenter: presenter)

            case .business:
                let presenter = BusinessCardDetailsPresenter(id: model.id)
                view?.goToBusinessCardDetails(presenter: presenter)
            }
        default:
            break
        }
    }


}

// MARK: - AlbumPreviewItemsViewDataSource

extension CardsOverviewViewPresenter: AlbumPreviewItemsViewDataSource {

    func albumPreviewItemsView(_ view: AlbumPreviewItemsTableViewCell, dataSourceID: String?) -> [PostPreview.Item] {
        guard let id = dataSourceID, id == CardsOverview.postsDataSourceID else {
            return []
        }
        return albumPreviewSection?.items ?? []
    }


}

// MARK: - AlbumPreviewItemsViewDelegate

extension CardsOverviewViewPresenter: AlbumPreviewItemsViewDelegate {

    func albumPreviewItemsView(_ view: AlbumPreviewItemsTableViewCell, didSelectedAt indexPath: IndexPath, dataSourceID: String?) {
        if let item = albumPreviewSection?.items[safe: indexPath.item] {
            switch item {
            case .add:
                break
            case .view(let model):
                let presenter = ArticleDetailsPresenter(albumID: model.albumID, articleID: model.articleID)
                self.view?.goToArticleDetails(presenter: presenter)
            case .showMore:
                break
            }
        }
    }


}
