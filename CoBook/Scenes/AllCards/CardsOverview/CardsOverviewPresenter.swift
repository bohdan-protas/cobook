//
//  CardsOverviewPresenter.swift
//  CoBook
//
//  Created by protas on 4/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import CoreLocation

protocol CardsOverviewView: AlertDisplayableView, LoadDisplayableView, NavigableView {
    func configureDataSource(with configurator: CardsOverviewViewDataSourceConfigurator)
    func setup(sections: [Section<CardsOverview.Items>])
    func reload(section: Section<CardsOverview.Items>, at index: Int)
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

    func mapTableViewCell(_ cell: MapTableViewCell, didUpdateVisibleRectBounds topLeft: CLLocationCoordinate2D?, bottomRight: CLLocationCoordinate2D?) {

    }


}
