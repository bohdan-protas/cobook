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
    func createFolder()
}

class SavedContentPresenter: BasePresenter {

    // Managed view
    weak var view: SavedContentView?
    private var dataSource: DataSource<SavedContentCellConfigurator>?

    // cards data source
    private var cardsTotalCount: Int = 0
    private var cards: [Int: [CardItemViewModel]] = [:]

    /// bar items busienss logic
    var barItems: [BarItem] = []
    var selectedBarItem: BarItem?

    // MARK: - Lifecycle

    init() {
        self.barItems = [
            BarItem(index: SavedContent.BarItemAccessoryIndex.allCards.rawValue, title: "BarItem.allCards".localized),
            BarItem(index: SavedContent.BarItemAccessoryIndex.personalCards.rawValue, title: "BarItem.personalCards".localized),
            BarItem(index: SavedContent.BarItemAccessoryIndex.businessCards.rawValue, title: "BarItem.businessCards".localized),
            BarItem(index: SavedContent.BarItemAccessoryIndex.inMyRegionCards.rawValue, title: "BarItem.myRegion".localized)
        ]

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

    // MARK: - Public

    func isEditableBarItemAt(index: Int) -> Bool {
        guard let item = barItems[safe: index] else {
            return false
        }

        return item.index >= 0 && item.index != index
    }

    func setup() {
        view?.startLoading()
        fetchUserFolders { [unowned self] (barItems) in
            self.view?.stopLoading()
            self.barItems.append(contentsOf: barItems)
            self.view?.set(barItems: self.barItems)
            self.updateViewDataSource()
            self.view?.reload()
            self.selectedBarItem = self.barItems.first
            self.updateCards()
        }
    }

    func selectedBarItemAt(index: Int) {
        self.selectedBarItem = barItems[safe: index]
        self.updateCards()
    }

    func createFolder(title: String, completion: ((BarItem) -> Void)?) {
        self.view?.startLoading()
        APIClient.default.createFolder(title: title) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()
            switch result {
            case .success(let response):
                if let id = response?.id {
                    let item = BarItem(index: id, title: title)
                    strongSelf.barItems.append(item)
                    strongSelf.view?.showTextHud("Список \(title) успішно створено")
                    completion?(item)
                }
            case .failure(let error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func updateFolder(at index: Int, withNewTitle title: String, completion: ((BarItem) -> Void)?) {
        guard var item = barItems[safe: index] else {
            return
        }

        self.view?.startLoading()
        APIClient.default.updateFolder(id: item.index, title: title) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()
            switch result {
            case .success:
                item.title = title
                strongSelf.barItems[safe: index] = item
                strongSelf.view?.showTextHud("Список \(title) успішно оновлено")
                completion?(item)
            case .failure(let error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func deleteFolder(at index: Int, successCompletion: (() -> Void)?) {
        if let folderID = barItems[safe: index]?.index {
            self.view?.startLoading()
            APIClient.default.deleteFolder(id: folderID) { [weak self] (result) in
                guard let strongSelf = self else { return }
                strongSelf.view?.stopLoading()
                switch result {
                case .success:
                    successCompletion?()
                    strongSelf.view?.showTextHud("Список \(self?.barItems[safe: index]?.title ?? "") видалено")
                case .failure(let error):
                    strongSelf.view?.errorAlert(message: error.localizedDescription)
                }
            }
        }

    }


}

// MARK - Privates

private extension SavedContentPresenter {

    func updateCards() {
        switch selectedBarItem?.index {
        case .none: break
        case .some(let index):

            switch index {
            case SavedContent.BarItemAccessoryIndex.allCards.rawValue:
                if self.cards[index]?.isEmpty ?? true {
                    fetchSavedCards { [unowned self] (cards) in
                        self.view?.stopLoading()
                        self.cards[index] = cards
                        self.updateViewDataSource()
                        self.view?.reload(section: .card)
                    }
                } else {
                    self.updateViewDataSource()
                    self.view?.reload(section: .card)
                }

            case SavedContent.BarItemAccessoryIndex.personalCards.rawValue:
                if self.cards[index]?.isEmpty ?? true {
                    fetchSavedCards(type: .personal) { [unowned self] (cards) in
                        self.view?.stopLoading()
                        self.cards[index] = cards
                        self.updateViewDataSource()
                        self.view?.reload(section: .card)
                    }
                } else {
                    self.updateViewDataSource()
                    self.view?.reload(section: .card)
                }

            case SavedContent.BarItemAccessoryIndex.businessCards.rawValue:
                if self.cards[index]?.isEmpty ?? true {
                    fetchSavedCards(type: .business) { [unowned self] (cards) in
                        self.view?.stopLoading()
                        self.cards[index] = cards
                        self.updateViewDataSource()
                        self.view?.reload(section: .card)
                    }
                } else {
                    self.updateViewDataSource()
                    self.view?.reload(section: .card)
                }

            case SavedContent.BarItemAccessoryIndex.inMyRegionCards.rawValue:
                self.updateViewDataSource()
                self.view?.reload(section: .card)

            // Another custom created lists
            default:
                if index >= 0 {
                    if self.cards[index]?.isEmpty ?? true {
                        fetchSavedCards(tagID: index) { [unowned self] (cards) in
                            self.view?.stopLoading()
                            self.cards[index] = cards
                            self.updateViewDataSource()
                            self.view?.reload(section: .card)
                        }
                    } else {
                        self.updateViewDataSource()
                        self.view?.reload(section: .card)
                    }
                }
                break
            }

        }
    }

    func updateViewDataSource() {
        dataSource?.sections[SavedContent.SectionAccessoryIndex.post.rawValue].items = [
            .title(model: SavedContent.TitleModel(title: "Збережені пости", counter: 0)),
            .sectionSeparator,
            .title(model: SavedContent.TitleModel(title: "Збережені візитки", counter: cardsTotalCount, actionTitle: "Додати cписок", actionHandler: { self.view?.createFolder() }))
        ]
        dataSource?.sections[SavedContent.SectionAccessoryIndex.card.rawValue].items = []

        if let index = selectedBarItem?.index {
            switch index {
            case SavedContent.BarItemAccessoryIndex.inMyRegionCards.rawValue:
                dataSource?.sections[SavedContent.SectionAccessoryIndex.card.rawValue].items = [.map]
            default:
                let cardsToShow = cards[index] ?? []
                dataSource?.sections[SavedContent.SectionAccessoryIndex.card.rawValue].items = cardsToShow.compactMap { .cardItem(model: $0) }
            }
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
                completion?([])
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}


