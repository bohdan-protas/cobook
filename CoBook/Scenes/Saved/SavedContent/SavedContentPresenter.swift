//
//  SavedContentPresenter.swift
//  CoBook
//
//  Created by protas on 5/14/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol SavedContentView: LoadDisplayableView, AlertDisplayableView {
    func set(dataSource: DataSource<SavedContentCellConfigurator>?)
    func reload(section: SavedContent.SectionAccessoryIndex)
    func reload()

    func set(barItems: [BarItem])
}

class SavedContentPresenter: BasePresenter {

    // Managed view
    weak var view: SavedContentView?
    private var dataSource: DataSource<SavedContentCellConfigurator>?

    // cards data source
    private var cardsTotalCount: Int = 0
    private var cards: [String: [CardItemViewModel]] = [:]

    /// bar items busienss logic
    var barItems: [BarItem] = []
    var selectedBarItem: BarItem?

    // MARK: - Public

    init() {
        // setup feed datasource
        dataSource = DataSource()
        dataSource?.sections = [Section<SavedContent.Cell>(accessoryIndex: SavedContent.SectionAccessoryIndex.post.rawValue, items: []),
                                Section<SavedContent.Cell>(accessoryIndex: CardsOverview.SectionAccessoryIndex.cards.rawValue, items: [])]
        dataSource?.configurator = dataSourceConfigurator
    }

    func attachView(_ view: SavedContentView) {
        self.view = view
        self.view?.set(dataSource: dataSource)
    }

    func detachView() {
        self.view = nil
    }

    func setup() {
        self.barItems = [
            BarItem(title: "BarItem.allCards".localized),
            BarItem(title: "BarItem.personalCards".localized),
            BarItem(title: "BarItem.businessCards".localized)
        ]

        view?.startLoading()
        fetchUserFolders { [unowned self] (barItems) in
            self.view?.stopLoading()

            self.barItems.append(contentsOf: barItems)
            self.barItems.append(BarItem(title: "BarItem.myRegion".localized))
            self.view?.set(barItems: self.barItems)
            self.updateViewDataSource()
            self.view?.reload()

            self.selectedBarItem = self.barItems.first
            self.updateCards()
        }
    }


}

// MARK: - HorizontalItemsBarViewDelegate

extension SavedContentPresenter: HorizontalItemsBarViewDelegate {

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItem item: BarItem?) {
        if selectedBarItem?.title == item?.title {
            return
        }

        self.selectedBarItem = item
        self.updateCards()
    }


}

// MARK - Privates

private extension SavedContentPresenter {

    func updateCards() {
        switch selectedBarItem?.title {
        case .none: break
        case .some(let title):

            switch title {
            case "BarItem.allCards".localized:

                if self.cards["BarItem.allCards".localized]?.isEmpty ?? true {
                    fetchSavedCards { [unowned self] (cards) in
                        self.view?.stopLoading()
                        self.cards["BarItem.allCards".localized] = cards
                        self.updateViewDataSource()
                        self.view?.reload(section: .card)
                    }
                } else {
                    self.updateViewDataSource()
                    self.view?.reload(section: .card)
                }

            case "BarItem.personalCards".localized:
                if self.cards["BarItem.personalCards".localized]?.isEmpty ?? true {
                    fetchSavedCards(type: .personal) { [unowned self] (cards) in
                        self.view?.stopLoading()
                        self.cards["BarItem.personalCards".localized] = cards
                        self.updateViewDataSource()
                        self.view?.reload(section: .card)
                    }
                } else {
                    self.updateViewDataSource()
                    self.view?.reload(section: .card)
                }

            case "BarItem.businessCards".localized:
                if self.cards["BarItem.businessCards".localized]?.isEmpty ?? true {
                    fetchSavedCards(type: .business) { [unowned self] (cards) in
                        self.view?.stopLoading()
                        self.cards["BarItem.businessCards".localized] = cards
                        self.updateViewDataSource()
                        self.view?.reload(section: .card)
                    }
                } else {
                    self.updateViewDataSource()
                     self.view?.reload(section: .card)
                }

            case "BarItem.myRegion".localized:
                break

            default:
                break
            }

        }
    }

    func updateViewDataSource() {
        dataSource?.sections[SavedContent.SectionAccessoryIndex.post.rawValue].items = [
            .title(model: SavedContent.TitleModel(title: "Збережені пости", counter: 0)),
            .sectionSeparator,
            .title(model: SavedContent.TitleModel(title: "Збережені візитки", counter: cardsTotalCount, actionTitle: "Додати візитку", actionHandler: { Log.debug("handle save") }))
        ]
        dataSource?.sections[SavedContent.SectionAccessoryIndex.card.rawValue].items = []

        if let title = selectedBarItem?.title {
            let cardsToShow = cards[title] ?? []
            dataSource?.sections[SavedContent.SectionAccessoryIndex.card.rawValue].items = cardsToShow.compactMap { .cardItem(model: $0) }
        }
    }

    func fetchUserFolders(completion: (([BarItem]) -> Void)?) {
        APIClient.default.getFolderList { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let folders):
                let items = folders?.compactMap { BarItem(index: $0.id, title: $0.title) }
                completion?(items ?? [])
            case .failure(let error):
                completion?([])
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func fetchSavedCards(tagID: Int? = nil, type: CardType? = nil, limit: Int? = nil, offset: Int? = nil, completion: (([CardItemViewModel]) -> Void)?) {
        view?.startLoading()
        APIClient.default.getSavedCardsList(tagID: tagID, type: type.map { $0.rawValue }, limit: limit, offset: offset) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()
            switch result {
            case .success(let cardDetails):
                strongSelf.cardsTotalCount = cardDetails?.totalCount ?? 0
                
                let cards = cardDetails?.rows?.compactMap { CardItemViewModel(id: $0.id,
                                                                              type: $0.type,
                                                                              avatarPath: $0.avatar?.sourceUrl,
                                                                              firstName: $0.cardCreator?.firstName,
                                                                              lastName: $0.cardCreator?.lastName,
                                                                              companyName: $0.company?.name,
                                                                              profession: $0.practiceType?.title,
                                                                              telephoneNumber: $0.contactTelephone?.number,
                                                                              isSaved: true) } ?? []
                completion?(cards)

            case .failure(let error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}


