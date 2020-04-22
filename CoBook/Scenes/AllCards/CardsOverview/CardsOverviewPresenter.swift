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

protocol CardsOverviewView: AlertDisplayableView, LoadDisplayableView, NavigableView {
    func set(dataSource: DataSource<CardsOverviewViewDataSourceConfigurator>?)
    func reload(section: CardsOverview.SectionAccessoryIndex)
    func reload()

    func set(searchDataSource: DataSource<CardsOverviewViewDataSourceConfigurator>?)
    func reloadSearch(resultText: String)

    func openSettings()
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

    /// Current pin request work item
    private var pendingCardPinRequestWorkItem: DispatchWorkItem?

    /// Current card search request work item
    private var pendingSearchResultWorkItem: DispatchWorkItem?

    // MARK: - BasePresenter

    override init() {

        self.barItems = [
            BarItem(index: CardsOverview.BarSectionsTypeIndex.allCards.rawValue, title: "Всі\nвізитки"),
            BarItem(index: CardsOverview.BarSectionsTypeIndex.personalCards.rawValue, title: "Персональні\nвізитки"),
            BarItem(index: CardsOverview.BarSectionsTypeIndex.businessCards.rawValue, title: "Бізнес\nвізитки"),
            BarItem(index: CardsOverview.BarSectionsTypeIndex.inMyRegionCards.rawValue, title: "В моєму\nрегіоні"),
        ]
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
            searchDataSource?[.header].items.removeAll()
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

                    let searchCards = response?.compactMap { CardItemViewModel(id: String($0.id),
                                                                               type: $0.type,
                                                                               avatarPath: $0.avatar?.sourceUrl,
                                                                               firstName: $0.cardCreator?.firstName,
                                                                               lastName: $0.cardCreator?.lastName,
                                                                               companyName: $0.company?.name,
                                                                               profession: $0.practiceType?.title,
                                                                               telephoneNumber: $0.contactTelephone?.number) } ?? []


                    strongSelf.searchDataSource?[.header].items = searchCards.map { .cardItem(model: $0) }
                    let text = searchCards.isEmpty ? "Немає результатів пошуку" : "Знайдено: \(searchCards.count)"
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

    func selectedCellAt(indexPath: IndexPath) {

        switch dataSource?.sections[safe: indexPath.section]?.items[indexPath.item] {
        case .some(let value):
            switch value {
            case .cardItem(let model):

                switch model?.type {
                case .some(let cardType):

                    switch cardType {

                    case .personal:
                        let personalCardDetailsViewController: PersonalCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
                        if let strid = model?.id, let id = Int(strid) {
                            personalCardDetailsViewController.presenter = PersonalCardDetailsPresenter(id: id)
                        }
                        view?.push(controller: personalCardDetailsViewController, animated: true)

                    case .business:
                        let businessCardDetailsViewController: BusinessCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
                        if let strid = model?.id, let id = Int(strid) {
                            businessCardDetailsViewController.presenter = BusinessCardDetailsPresenter(id: id)
                        }
                        view?.push(controller: businessCardDetailsViewController, animated: true)
                    }

                default: break
                }

            default: break
            }
        case .none:
            break

        }

    }


}

// MARK: - Use Cases

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

                strongSelf.allCards = response?.compactMap { CardItemViewModel(id: String($0.id),
                                                                               type: $0.type,
                                                                               avatarPath: $0.avatar?.sourceUrl,
                                                                               firstName: $0.cardCreator?.firstName,
                                                                               lastName: $0.cardCreator?.lastName,
                                                                               companyName: $0.company?.name,
                                                                               profession: $0.practiceType?.title,
                                                                               telephoneNumber: $0.contactTelephone?.number) } ?? []

                strongSelf.personalCards = strongSelf.allCards.filter { $0.type == .personal }
                strongSelf.businessCards = strongSelf.allCards.filter { $0.type == .business }

                strongSelf.setupViewDataSource()
                strongSelf.view?.reload()
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}

// MARK: - Rendering

private extension CardsOverviewViewPresenter {

    func setupViewDataSource() {
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
    }

}

// MARK: - HorizontalItemsBarViewDelegate

extension CardsOverviewViewPresenter: HorizontalItemsBarViewDelegate {

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int) {
        selectedBarItem = barItems[safe: index]
        setupViewDataSource()
        self.view?.reload(section: .cards)
    }


}

// MARK: - MapTableViewCellDelegate

extension CardsOverviewViewPresenter: MapTableViewCellDelegate {
    
    func openSettingsAction(_ cell: MapTableViewCell) {
        view?.openSettings()
    }

    func mapTableViewCell(_ cell: MapTableViewCell, didUpdateVisibleRectBounds topLeft: CLLocationCoordinate2D?, bottomRight: CLLocationCoordinate2D?) {
        pendingCardPinRequestWorkItem?.cancel()

        pendingCardPinRequestWorkItem = DispatchWorkItem { [weak self] in
            let topLeftRectCoordinate = CoordinateApiModel(latitude: topLeft?.latitude, longitude: topLeft?.longitude)
            let bottomRightRectCoordinate = CoordinateApiModel(latitude: bottomRight?.latitude, longitude: bottomRight?.longitude)

            APIClient.default.getCardLocationsInRegion(topLeftRectCoordinate: topLeftRectCoordinate, bottomRightRectCoordinate: bottomRightRectCoordinate) { [weak self] (result) in
                switch result {
                case .success(let response):
                    let markers: [GMSMarker] = response?.compactMap { apiModel in
                        if let latitide = apiModel.latitide, let longiture = apiModel.longiture {
                            let position = CLLocationCoordinate2D(latitude: latitide, longitude: longiture)
                            let marker = GMSMarker(position: position)

                            switch apiModel.type {
                            case .personal:
                                marker.icon = UIImage(named: "ic_mapmarker_personal")
                            case .business:
                                marker.icon = UIImage(named: "ic_mapmarker_business")
                            }
                            return marker
                        } else {
                            return nil
                        }
                    } ?? []

                    cell.markers = markers
                case .failure(let error):
                    self?.view?.errorAlert(message: error.localizedDescription)
                }
            }
        }

        if pendingCardPinRequestWorkItem != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: pendingCardPinRequestWorkItem!)
        }
    }


}
