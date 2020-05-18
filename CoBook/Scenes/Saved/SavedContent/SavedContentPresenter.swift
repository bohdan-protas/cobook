//
//  SavedContentPresenter.swift
//  CoBook
//
//  Created by protas on 5/14/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol SavedContentView: LoadDisplayableView, AlertDisplayableView, ContactableCardItemTableViewCellDelegate {
    func set(dataSource: DataSource<SavedContentCellConfigurator>?)
    func reload(section: SavedContent.SectionAccessoryIndex)
    func reloadItemAt(indexPath: IndexPath)
    func reload()
    func set(barItems: [BarItem])
    func createFolder()
    func goToBusinessCardDetails(presenter: BusinessCardDetailsPresenter?)
    func goToPersonalCardDetails(presenter: PersonalCardDetailsPresenter?)
    func goToArticleDetails(presenter: ArticleDetailsPresenter)
}

class SavedContentPresenter: BasePresenter {

    // Managed view
    weak var view: SavedContentView?
    private var dataSource: DataSource<SavedContentCellConfigurator>?

    // cards data source
    private var albumPreviewItems: [AlbumPreview.Item.Model] = []
    private var albumPreviewSection: AlbumPreview.Section?

    private var cardsTotalCount: Int = 0
    private var cards: [Int: [CardItemViewModel]] = [:]
    private var isInitialFetch: Bool = true

    /// bar items busienss logic
    var barItems: [BarItem] = []
    var selectedBarItem: BarItem?

    // MARK: - Lifecycle

    init() {
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

    func setup(useLoader: Bool) {
        let group = DispatchGroup()

        isInitialFetch = true
        if useLoader { view?.startLoading() }

        group.enter()
        fetchUserFolders { [unowned self] (barItems) in
            self.view?.stopLoading()
            self.barItems = [
                BarItem(index: SavedContent.BarItemAccessoryIndex.allCards.rawValue, title: "BarItem.allCards".localized),
                BarItem(index: SavedContent.BarItemAccessoryIndex.personalCards.rawValue, title: "BarItem.personalCards".localized),
                BarItem(index: SavedContent.BarItemAccessoryIndex.businessCards.rawValue, title: "BarItem.businessCards".localized),
                BarItem(index: SavedContent.BarItemAccessoryIndex.inMyRegionCards.rawValue, title: "BarItem.myRegion".localized)
            ]

            self.barItems.append(contentsOf: barItems)
            self.selectedBarItem = self.barItems.first
            group.leave()
        }

        // fetch albums list
        group.enter()
        APIClient.default.getUserFavouritedArticles(limit: 50, offset: nil) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.albumPreviewItems = response?.rows?.compactMap { AlbumPreview.Item.Model(id: $0.id,
                                                                                                    title: $0.title,
                                                                                                    avatarPath: $0.avatar?.sourceUrl,
                                                                                                    avatarID: $0.avatar?.id) } ?? []
                group.leave()
            case .failure(let error):
                self?.view?.errorAlert(message: error.localizedDescription)
                group.leave()
            }
        }

        // setup data source
        group.notify(queue: .main) { [unowned self] in
            self.view?.stopLoading()

            /// Datasource configuration
            self.view?.set(barItems: self.barItems)
            self.updateCards(useLoader: useLoader)
        }



    }

    func isEditableBarItemAt(index: Int) -> Bool {
        guard let item = barItems[safe: index] else {
            return false
        }

        return item.index >= 0 && item.index != index
    }

    func telephoneNumberForItemAt(indexPath: IndexPath) -> String? {
        if let item = dataSource?.sections[indexPath.section].items[indexPath.row] {
            switch item {
            case .cardItem(let model):
                return model.telephoneNumber
            default: break
            }
        }
        return nil
    }

    func emailAddressForItemAt(indexPath: IndexPath) -> String? {
        if let item = dataSource?.sections[indexPath.section].items[indexPath.row] {
            switch item {
            case .cardItem:
                // FIXME: Check api model for aviable email address
                return nil
            default: break
            }
        }
        return nil
    }

    func selectedBarItemAt(index: Int) {
        self.selectedBarItem = barItems[safe: index]
        self.updateCards(useLoader: true)
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

    func saveCardAt(indexPath: IndexPath, successCompletion: ((_ currentState: Bool) -> Void)?) {
        if let item = dataSource?.sections[indexPath.section].items[indexPath.row] {

            switch item {
            case .cardItem(let model):
                switch model.isSaved {
                case false:
                    view?.startLoading()
                    APIClient.default.addCardToFavourites(id: model.id) { [weak self] (result) in
                        switch result {
                        case .success:
                            self?.updateCardItem(id: model.id, withSavedFlag: true)
                            NotificationCenter.default.post(name: .cardSaved, object: nil, userInfo: [Notification.Key.cardID: model.id, Notification.Key.controllerID: SavedContentViewController.describing])
                            self?.view?.stopLoading(success: true, succesText: "Card.Saved".localized, failureText: nil, completion: nil)
                            successCompletion?(true)
                        case .failure:
                            self?.view?.stopLoading(success: false)
                        }
                    }
                case true:
                    view?.startLoading()
                    APIClient.default.deleteCardFromFavourites(id: model.id) { [weak self] (result) in
                        switch result {
                        case .success:
                            self?.updateCardItem(id: model.id, withSavedFlag: false)
                            NotificationCenter.default.post(name: .cardUnsaved, object: nil, userInfo: [Notification.Key.cardID: model.id, Notification.Key.controllerID: SavedContentViewController.describing])
                            self?.view?.stopLoading(success: true, succesText: "Card.Unsaved".localized, failureText: nil, completion: nil)
                            successCompletion?(false)
                        case .failure:
                            self?.view?.stopLoading(success: false)
                        }
                    }
                }
            default: break
            }
        }
    }


    func selectedCellAt(indexPath: IndexPath) {
        guard let item = dataSource?.sections[safe: indexPath.section]?.items[indexPath.item] else {
            return
        }
        goToItem(item)
    }

    func updateCardItem(id: Int, withSavedFlag flag: Bool) {
        if let allCardsIndex = cards[SavedContent.BarItemAccessoryIndex.allCards.rawValue]?.firstIndex(where: { $0.id == id }) {
            cards[SavedContent.BarItemAccessoryIndex.allCards.rawValue]?[safe: allCardsIndex]?.isSaved = flag
        }

        if let personalCardsIndex = cards[SavedContent.BarItemAccessoryIndex.personalCards.rawValue]?.firstIndex(where: { $0.id == id }) {
            cards[SavedContent.BarItemAccessoryIndex.personalCards.rawValue]?[safe: personalCardsIndex]?.isSaved = flag
        }

        if let businessCardsIndex = cards[SavedContent.BarItemAccessoryIndex.businessCards.rawValue]?.firstIndex(where: { $0.id == id }) {
            cards[SavedContent.BarItemAccessoryIndex.businessCards.rawValue]?[safe: businessCardsIndex]?.isSaved = flag
        }
        updateViewDataSource()
    }

}

// MARK - Privates

private extension SavedContentPresenter {

    func goToItem(_ item: SavedContent.Cell) {
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
        default: break
        }
    }


    func updateCards(useLoader: Bool) {
        switch selectedBarItem?.index {
        case .none: break
        case .some(let index):

            switch index {
            case SavedContent.BarItemAccessoryIndex.allCards.rawValue:
                if self.cards[index]?.isEmpty ?? true || isInitialFetch {
                    if useLoader { view?.startLoading() }
                    fetchSavedCards { [unowned self] (cards) in
                        self.view?.stopLoading()
                        self.cards[index] = cards
                        self.updateViewDataSource()
                        if self.isInitialFetch {
                            self.view?.reload()
                            self.isInitialFetch = false
                        } else {
                            self.view?.reload(section: .card)
                        }
                    }
                } else {
                    self.updateViewDataSource()
                    if self.isInitialFetch {
                        self.view?.reload()
                        self.isInitialFetch = false
                    } else {
                        self.view?.reload(section: .card)
                    }
                }

            case SavedContent.BarItemAccessoryIndex.personalCards.rawValue:
                if self.cards[index]?.isEmpty ?? true || isInitialFetch {
                    if useLoader { view?.startLoading() }
                    fetchSavedCards(type: .personal) { [unowned self] (cards) in
                        self.view?.stopLoading()
                        self.cards[index] = cards
                        self.updateViewDataSource()
                        if self.isInitialFetch {
                            self.view?.reload()
                            self.isInitialFetch = false
                        } else {
                            self.view?.reload(section: .card)
                        }
                    }
                } else {
                    self.updateViewDataSource()
                    if isInitialFetch {
                        self.view?.reload()
                        self.isInitialFetch = false
                    } else {
                        self.view?.reload(section: .card)
                    }
                }

            case SavedContent.BarItemAccessoryIndex.businessCards.rawValue:
                if self.cards[index]?.isEmpty ?? true || isInitialFetch {
                    if useLoader { view?.startLoading() }
                    fetchSavedCards(type: .business) { [unowned self] (cards) in
                        self.view?.stopLoading()
                        self.cards[index] = cards
                        self.updateViewDataSource()
                        if self.isInitialFetch {
                            self.view?.reload()
                            self.isInitialFetch = false
                        } else {
                            self.view?.reload(section: .card)
                        }
                    }
                } else {
                    self.updateViewDataSource()
                    if isInitialFetch {
                        self.view?.reload()
                        self.isInitialFetch = false
                    } else {
                        self.view?.reload(section: .card)
                    }
                }

            case SavedContent.BarItemAccessoryIndex.inMyRegionCards.rawValue:
                self.updateViewDataSource()
                if isInitialFetch {
                    self.view?.reload()
                    self.isInitialFetch = false
                } else {
                    self.view?.reload(section: .card)
                }

            // Another custom created lists
            default:
                if index >= 0 {
                    if self.cards[index]?.isEmpty ?? true || isInitialFetch{
                        if useLoader { view?.startLoading() }
                        fetchSavedCards(tagID: index) { [unowned self] (cards) in
                            self.view?.stopLoading()
                            self.cards[index] = cards
                            self.updateViewDataSource()
                            if self.isInitialFetch {
                                 self.view?.reload()
                                 self.isInitialFetch = false
                             } else {
                                 self.view?.reload(section: .card)
                             }
                        }
                    } else {
                        self.updateViewDataSource()
                        if self.isInitialFetch {
                             self.view?.reload()
                             self.isInitialFetch = false
                         } else {
                             self.view?.reload(section: .card)
                         }
                    }
                }
                break
            }

        }
    }

    func updateViewDataSource() {
        // Post preview section
        dataSource?[.postPreview].items.removeAll()
        let items = albumPreviewItems.compactMap { AlbumPreview.Item.view($0) }
        albumPreviewSection = AlbumPreview.Section(title: "Збережені пости: \(items.count)", dataSourceID: BusinessCardDetails.PostPreviewDataSourceID.albumPreviews.rawValue, items: [])
        albumPreviewSection?.items.append(contentsOf: items)
        //albumPreviewSection?.items.append(.showMore)
        dataSource?[.postPreview].items = []

        dataSource?.sections[SavedContent.SectionAccessoryIndex.post.rawValue].items = [
            .postPreview(model: albumPreviewSection),
            .sectionSeparator,
            .title(model: SavedContent.TitleModel(title: "Збережені візитки", counter: cardsTotalCount, actionTitle: "Додати cписок", actionHandler: { self.view?.createFolder() })),
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
        APIClient.default.getSavedCardsList(tagID: tagID, type: type.map { $0.rawValue }, limit: limit, offset: offset) { [weak self] (result) in
            guard let strongSelf = self else { return }
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

// MARK: - AlbumPreviewItemsViewDelegate

extension SavedContentPresenter: AlbumPreviewItemsViewDelegate {

    func albumPreviewItemsView(_ view: AlbumPreviewItemsTableViewCell, didSelectedAt indexPath: IndexPath, dataSourceID: String?) {
        guard let id = dataSourceID, let dataSource = SavedContent.PostPreviewDataSourceID(rawValue: id) else {
            return
        }

        switch dataSource {
        case .albumPreviews:
            if let selectedItem = albumPreviewSection?.items[safe: indexPath.item] {
                switch selectedItem {
                case .add: break
                    //self.view?.goToCreatePost(cardID: businessCardId)
                case .view(let model):
                    let presenter = ArticleDetailsPresenter(albumID: model.id, cardID: -1)
                    self.view?.goToArticleDetails(presenter: presenter)
                case .showMore:
                    break
                }
            }
        }
    }


}

// MARK: - AlbumPreviewItemsViewDataSource

extension SavedContentPresenter: AlbumPreviewItemsViewDataSource {

    func albumPreviewItemsView(_ view: AlbumPreviewItemsTableViewCell, dataSourceID: String?) -> [AlbumPreview.Item] {
        guard let id = dataSourceID, let dataSource = SavedContent.PostPreviewDataSourceID(rawValue: id) else {
            return []
        }

        switch dataSource {
        case .albumPreviews:
            return albumPreviewSection?.items ?? []
        }
    }


}



