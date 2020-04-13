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
    func configureDataSource(with configurator: CardsOverviewViewDataSourceConfigurator)
    func setup(sections: [Section<CardsOverview.Items>])
    func setupSearch(sections: [Section<CardsOverview.Items>])
    func reload(section: Section<CardsOverview.Items>, at index: Int)
    func openSettings()
}

class CardsOverviewViewPresenter: NSObject, BasePresenter {

    private weak var view: CardsOverviewView?
    private lazy var dataSourceConfigurator: CardsOverviewViewDataSourceConfigurator = {
        let dataSourceConfigurator = CardsOverviewViewDataSourceConfigurator(presenter: self)
        return dataSourceConfigurator
    }()

    var barItems: [BarItemViewModel] {
        get {
            return [
                BarItemViewModel(index: CardsOverview.BarSectionsTypeIndex.allCards.rawValue, title: "Всі\nвізитки"),
                BarItemViewModel(index: CardsOverview.BarSectionsTypeIndex.personalCards.rawValue, title: "Персональні\nвізитки"),
                BarItemViewModel(index: CardsOverview.BarSectionsTypeIndex.businessCards.rawValue, title: "Бізнес\nвізитки"),
                BarItemViewModel(index: CardsOverview.BarSectionsTypeIndex.inMyRegionCards.rawValue, title: "В моєму\nрегіоні"),
            ]
        }
    }

    private var selectedBarItem: BarItemViewModel? {
        didSet {
            updateViewDataSoure(section: 1)
        }
    }

    private var postsSection: Section<CardsOverview.Items> = Section(items: [])
    private var changableSection: Section<CardsOverview.Items> = Section(items: [])

    private var allCards: [CardItemViewModel] = []
    private var personalCards: [CardItemViewModel] = []
    private var businessCards: [CardItemViewModel] = []

    /// Current pin request work item
    private var pendingCardPinRequestWorkItem: DispatchWorkItem?

    /// Current card search request work item
    private var pendingSearchResultWorkItem: DispatchWorkItem?

    // MARK: - BasePresenter

    func attachView(_ view: CardsOverviewView) {
        self.view = view
        self.view?.configureDataSource(with: dataSourceConfigurator)
    }

    func detachView() {
        view = nil
    }

    // MARK: - Public

    func onViewDidLoad() {
        getAllCardsList()
    }

    func updateSearchResult(query: String) {
        pendingSearchResultWorkItem?.cancel()

        if query.isEmpty {
            view?.setupSearch(sections: [])
            return
        }
        
        pendingSearchResultWorkItem = DispatchWorkItem { [weak self] in
            APIClient.default.getCardsList(search: query) { [weak self] result in
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

                    var searchSection: Section<CardsOverview.Items> = Section(items: [])
                    searchSection.items = searchCards.map { .cardItem(model: $0) }
                    strongSelf.view?.setupSearch(sections: [searchSection])

                case .failure(let error):
                    strongSelf.view?.errorAlert(message: error.localizedDescription)
                }
            }
        }

        if pendingSearchResultWorkItem != nil, !(pendingSearchResultWorkItem?.isCancelled ?? true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: pendingSearchResultWorkItem!)
        }
    }


}

// MARK: - Use Cases

private extension CardsOverviewViewPresenter {

    func getAllCardsList() {
        view?.startLoading()
        APIClient.default.getCardsList { [weak self] (result) in
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
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}

// MARK: - Rendering

private extension CardsOverviewViewPresenter {

    func setupViewDataSource() {
        postsSection.items = []
        changableSection.items = allCards.map { .cardItem(model: $0) }
        view?.setup(sections: [postsSection, changableSection])
    }

    func updateViewDataSoure(section: Int) {
        if let item = CardsOverview.BarSectionsTypeIndex(rawValue: selectedBarItem?.index ?? -1) {
            switch item {
            case .allCards:
                changableSection.items = allCards.map { .cardItem(model: $0) }
            case .personalCards:
                changableSection.items = personalCards.map { .cardItem(model: $0) }
            case .businessCards:
                changableSection.items = businessCards.map { .cardItem(model: $0) }
            case .inMyRegionCards:
                changableSection.items = [.map]
            }
        }

        view?.reload(section: changableSection, at: section)
    }


}

// MARK: - HorizontalItemsBarViewDelegate

extension CardsOverviewViewPresenter: HorizontalItemsBarViewDelegate {

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int) {
        selectedBarItem = barItems[safe: index]
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
