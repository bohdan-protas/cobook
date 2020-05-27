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

    func set(dataSource: DataSource<CardsOverviewViewDataSourceConfigurator>?)
    func reload(section: CardsOverview.SectionAccessoryIndex)
    func reloadItemAt(indexPath: IndexPath)
    func reload()

    func set(searchDataSource: DataSource<CardsOverviewViewDataSourceConfigurator>?)
    func reloadSearch(resultText: String)

    func openSettings()
    func goToBusinessCardDetails(presenter: BusinessCardDetailsPresenter?)
    func goToPersonalCardDetails(presenter: PersonalCardDetailsPresenter?)

}

class CardsOverviewViewPresenter: NSObject, BasePresenter {

    /// managed view
    weak var view: CardsOverviewView?

    /// bar items busienss logic
    var barItems: [BarItem]
    var selectedBarItem: BarItem?

    private var dataSource: DataSource<CardsOverviewViewDataSourceConfigurator>?
    private var searchDataSource: DataSource<CardsOverviewViewDataSourceConfigurator>?

    /// cards data source
    private var allCards: [CardItemViewModel] = []
    private var personalCards: [CardItemViewModel] = []
    private var businessCards: [CardItemViewModel] = []
    private var searchCards: [CardItemViewModel] = []

    private var cards: [Int: [CardItemViewModel]] = [:]

    /// Current pin request work item
    private var pendingCardMapMarkersRequestWorkItem: DispatchWorkItem?

    /// Current card search request work item
    private var pendingSearchResultWorkItem: DispatchWorkItem?

    private var isNewFolderSaving: Bool = false

    // MARK: - BasePresenter

    override init() {
        self.barItems = [
            BarItem(index: CardsOverview.BarSectionsTypeIndex.allCards.rawValue, title: "BarItem.allCards".localized),
            BarItem(index: CardsOverview.BarSectionsTypeIndex.personalCards.rawValue, title: "BarItem.personalCards".localized),
            BarItem(index: CardsOverview.BarSectionsTypeIndex.businessCards.rawValue, title: "BarItem.businessCards".localized),
            BarItem(index: CardsOverview.BarSectionsTypeIndex.inMyRegionCards.rawValue, title: "BarItem.myRegion".localized),
        ].sorted { $0.index < $1.index }
        self.selectedBarItem = barItems.first
        super.init()

        // setup feed datasource
        dataSource = DataSource()
        dataSource?.sections = [Section<CardsOverview.Items>(accessoryIndex: CardsOverview.SectionAccessoryIndex.header.rawValue, items: []),
                                Section<CardsOverview.Items>(accessoryIndex: CardsOverview.SectionAccessoryIndex.cards.rawValue, items: [])]
        dataSource?.configurator = dataSourceConfigurator

        // setup search datasource
        searchDataSource = DataSource(configurator: dataSourceConfigurator)
        searchDataSource?.sections = [Section<CardsOverview.Items>(accessoryIndex: CardsOverview.SectionAccessoryIndex.header.rawValue, items: [])]
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

    func onViewDidLoad() {
        getAllCardsList()
    }

    func refreshDataSource() {
        getAllCardsList()
    }

    func updateSearchResult(query: String) {
        pendingSearchResultWorkItem?.cancel()
        if query.isEmpty {
            searchDataSource?[CardsOverview.SectionAccessoryIndex.header].items.removeAll()
            view?.reloadSearch(resultText: "Немає результатів пошуку")
            return
        }
        
        pendingSearchResultWorkItem = DispatchWorkItem { [weak self] in
            let interests = AppStorage.User.Filters?.interests
            let practiceTypeIds = AppStorage.User.Filters?.practicies
            APIClient.default.getCardsList(interestIds: interests, practiseTypeIds: practiceTypeIds, search: query) { [weak self] result in
                guard let strongSelf = self else { return }

                switch result {
                case .success(let response):

                    strongSelf.searchCards = response?.compactMap { CardItemViewModel(id: $0.id,
                                                                                      type: $0.type,
                                                                                      avatarPath: $0.avatar?.sourceUrl,
                                                                                      firstName: $0.cardCreator?.firstName,
                                                                                      lastName: $0.cardCreator?.lastName,
                                                                                      companyName: $0.company?.name,
                                                                                      profession: $0.practiceType?.title,
                                                                                      telephoneNumber: $0.contactTelephone?.number,
                                                                                      isSaved: $0.isSaved ?? false) } ?? []

                    let text = strongSelf.searchCards.isEmpty ? "Немає результатів пошуку" : "Знайдено: \(strongSelf.searchCards.count) візитки"
                    strongSelf.updateViewDataSource()
                    strongSelf.view?.reloadSearch(resultText: text)


                case .failure(let error):
                    strongSelf.view?.errorAlert(message: error.localizedDescription)
                }
            }
        }

        if pendingSearchResultWorkItem != nil, !(pendingSearchResultWorkItem?.isCancelled ?? true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: pendingSearchResultWorkItem!)
        }
    }

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
            default: break
            }
        }
    }

    func updateCardItem(id: Int, withSavedFlag flag: Bool) {
        if let allCardsIndex = allCards.firstIndex(where: { $0.id == id }) {
            allCards[allCardsIndex].isSaved = flag
        }

        if let personalCardsIndex = personalCards.firstIndex(where: { $0.id == id }) {
            personalCards[personalCardsIndex].isSaved = flag
        }

        if let businessCardsIndex = businessCards.firstIndex(where: { $0.id == id }) {
            businessCards[businessCardsIndex].isSaved = flag
        }

        if let searchCardsIndex = searchCards.firstIndex(where: { $0.id == id }) {
            searchCards[searchCardsIndex].isSaved = flag
        }

        updateViewDataSource()
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

}

// MARK: - Privates

private extension CardsOverviewViewPresenter {

    func getAllCardsList() {
        view?.startLoading()

        let interests = AppStorage.User.Filters?.interests
        let practiceTypeIds = AppStorage.User.Filters?.practicies

        APIClient.default.getCardsList(interestIds: interests, practiseTypeIds: practiceTypeIds) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            switch result {
            case let .success(response):

                strongSelf.allCards = response?.compactMap { CardItemViewModel(id: $0.id,
                                                                               type: $0.type,
                                                                               avatarPath: $0.avatar?.sourceUrl,
                                                                               firstName: $0.cardCreator?.firstName,
                                                                               lastName: $0.cardCreator?.lastName,
                                                                               companyName: $0.company?.name,
                                                                               profession: $0.practiceType?.title,
                                                                               telephoneNumber: $0.contactTelephone?.number,
                                                                               isSaved: $0.isSaved ?? false) } ?? []

                strongSelf.personalCards = strongSelf.allCards.filter { $0.type == .personal }
                strongSelf.businessCards = strongSelf.allCards.filter { $0.type == .business }

                strongSelf.updateViewDataSource()
                strongSelf.view?.reload()
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func updateViewDataSource() {
        if let item = CardsOverview.BarSectionsTypeIndex(rawValue: selectedBarItem?.index ?? -1) {
            switch item {
            case .allCards:
                dataSource?[.cards].items = allCards.map { .cardItem(model: $0) }
            case .personalCards:
                dataSource?[.cards].items = personalCards.map { .cardItem(model: $0) }
            case .businessCards:
                dataSource?[.cards].items = businessCards.map { .cardItem(model: $0) }
            case .inMyRegionCards:
                dataSource?[.cards].items = [.map]
            }
        }
        searchDataSource?[CardsOverview.SectionAccessoryIndex.header].items = searchCards.map { .cardItem(model: $0) }
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
                self?.view?.stopLoading(success: true, succesText: "Card.Saved".localized, failureText: nil, completion: nil)
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
                self?.view?.stopLoading(success: true, succesText: "Card.Unsaved".localized, failureText: nil, completion: nil)
            case .failure:
                completion?(false)
                self?.view?.stopLoading(success: false)
            }
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
        case .map:
            break
        }
    }


}

// MARK: - HorizontalItemsBarViewDelegate

extension CardsOverviewViewPresenter: HorizontalItemsBarViewDelegate {

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int) {
        selectedBarItem = barItems[safe: index]
        updateViewDataSource()
        self.view?.reload(section: .cards)
    }


}

