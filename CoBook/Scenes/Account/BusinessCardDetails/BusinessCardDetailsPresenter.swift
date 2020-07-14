//
//  BusinessCardDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseDynamicLinks
import PortmoneSDKEcom

protocol BusinessCardDetailsView: AlertDisplayableView, LoadDisplayableView, NavigableView, MessagingCallingView, MapDirectionTableViewCellDelegate, ShareableView, BusinessCardHeaderInfoTableViewCellDelegate, ExpandableDescriptionTableViewCellDelegate {
    func set(dataSource: TableDataSource<BusinessCardDetailsDataSourceConfigurator>?)
    func reload(section: BusinessCardDetails.SectionAccessoryIndex, animation: UITableView.RowAnimation)
    func reload()
    func setupEditCardView()
    func setupHideCardView()
    func updateRows(insertion: [IndexPath], deletion: [IndexPath], insertionAnimation: UITableView.RowAnimation, deletionAnimation: UITableView.RowAnimation)
    
    func goToCreateService(presenter: CreateServicePresenter?)
    func goToServiceDetails(presenter: ServiceDetailsPresenter?)
    func goToCreateProduct(presenter: CreateProductPresenter?)
    func goToProductDetails(presenter: ProductDetailsPresenter?)
    func goToCreatePost(cardID: Int)
    func goToArticleDetails(presenter: ArticleDetailsPresenter)
    func goToCreateFeedback(presenter: AddFeedbackPresenter)
    func goToPersonalCardDetails(presenter: PersonalCardDetailsPresenter)
    func showPaymentCard(presenter: PaymentPresenter, params: PaymentParams)
    func businessCardPayment(cardID: Int)
    func openPhotoGallery(photos: [String], activedPhotoIndex: Int)
}

fileprivate enum Layout {
    static let maxCollapsedDescrCount: Int = 200
}

class BusinessCardDetailsPresenter: NSObject, BasePresenter {

    /// Managed view
    weak var view: BusinessCardDetailsView?

    /// bar items busienss logic
    var barItems: [BarItem]
    var selectedBarItem: BarItem

    /// Datasource
    var businessCardId: Int
    private var cardDetails: CardDetailsApiModel?
    private var employee: [EmployeeModel] = []
    private var services: [Service.PreviewModel] = []
    private var products: [ProductPreviewSectionModel] = []
    private var comments: [FeedbackItemApiModel] = []
    private var albumPreviewItems: [PostPreview.Item.Model] = []
    private var albumPreviewSection: PostPreview.Section?
    
    /// View datasource
    private var dataSource: TableDataSource<BusinessCardDetailsDataSourceConfigurator>?

    /// Flag for owner identifire
    private var isUserOwner: Bool {
        return AppStorage.User.Profile?.userId == cardDetails?.cardCreator?.id
    }

    // MARK: - Object Lifecycle

    init(id: Int) {
        self.businessCardId = id
        self.barItems = [
            BarItem(index: BusinessCardDetails.BarSectionsTypeIndex.general.rawValue, title: "BarItem.generalInfo".localized),
            BarItem(index: BusinessCardDetails.BarSectionsTypeIndex.services.rawValue, title: "BarItem.services".localized),
            BarItem(index: BusinessCardDetails.BarSectionsTypeIndex.products.rawValue, title: "BarItem.shop".localized),
            BarItem(index: BusinessCardDetails.BarSectionsTypeIndex.team.rawValue, title: "BarItem.team".localized),
            BarItem(index: BusinessCardDetails.BarSectionsTypeIndex.responds.rawValue, title: "BarItem.feedbacks".localized),
            BarItem(index: BusinessCardDetails.BarSectionsTypeIndex.contacts.rawValue, title: "BarItem.contacts".localized),
        ].sorted { $0.index < $1.index }
        self.selectedBarItem = barItems.first!

        super.init()
        self.dataSource = TableDataSource(configurator: dataSouceConfigurator)
        self.dataSource?.sections = [
            Section<BusinessCardDetails.Cell>(accessoryIndex: BusinessCardDetails.SectionAccessoryIndex.userHeader.rawValue, items: []),
            Section<BusinessCardDetails.Cell>(accessoryIndex: BusinessCardDetails.SectionAccessoryIndex.postPreview.rawValue, items: []),
            Section<BusinessCardDetails.Cell>(accessoryIndex: BusinessCardDetails.SectionAccessoryIndex.cardDetails.rawValue, items: [])
        ]
    }

    // MARK: - Public

    func attachView(_ view: BusinessCardDetailsView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    func onViewWillAppear() {
        fetchDataSource()
    }

    func editBusinessCard() {
        if let cardDetails = cardDetails {
            let businessCardDetails = CreateBusinessCard.DetailsModel.init(apiModel: cardDetails)
            let presenter = CreateBusinessCardPresenter(detailsModel: businessCardDetails)
            let controller: CreateBusinessCardViewController = UIStoryboard.account.initiateViewControllerFromType()
            controller.presenter = presenter
            view?.push(controller: controller, animated: true)
        } else {
            let controller: CreateBusinessCardViewController = UIStoryboard.account.initiateViewControllerFromType()
            view?.push(controller: controller, animated: true)
        }
    }

    func selectedRow(at indexPath: IndexPath) {
        guard let item = dataSource?.sections[safe: indexPath.section]?.items[safe: indexPath.item] else {
            Log.debug("Cannot select \(indexPath)")
            return
        }

        switch item {
        case .service(let model):
            switch model {
            case .view(let model):
                let presenter = ServiceDetailsPresenter(serviceID: model.id ?? -1, cardID: businessCardId, companyName: cardDetails?.company?.name, companyAvatar: cardDetails?.avatar?.sourceUrl, isUserOwner: isUserOwner)
                view?.goToServiceDetails(presenter: presenter)
            case .add:
                let presenter = CreateServicePresenter(businessCardID: businessCardId, companyName: cardDetails?.company?.name, companyAvatar: cardDetails?.avatar?.sourceUrl)
                view?.goToCreateService(presenter: presenter)
            }

        case .addProduct:
            let presenter = CreateProductPresenter(businessCardID: businessCardId, companyName: cardDetails?.company?.name, companyAvatar: cardDetails?.avatar?.sourceUrl)
            view?.goToCreateProduct(presenter: presenter)

            
        case .employee(let model):
            if let id = model?.cardId {
                let presenter = PersonalCardDetailsPresenter(id: id)
                view?.goToPersonalCardDetails(presenter: presenter)
            }
            
        default:
            break
        }
    }

    func getRouteDestination(callback: ((CLLocationCoordinate2D?) -> Void)?) {
        guard let addressId = self.cardDetails?.address?.googlePlaceId else {
            view?.errorAlert(message: "Error.Map.notDefinedRoute.message".localized)
            return
        }

        GMSPlacesClient.shared().fetchPlace(fromPlaceID: addressId, placeFields: .all, sessionToken: nil) { [unowned self] (place, error) in
            DispatchQueue.main.async {
                if error != nil {
                    let errorDescr = error?.localizedDescription ?? "Error.Map.notDefinedRoute.message".localized
                    self.view?.errorAlert(message: errorDescr)
                }
                callback?(place?.coordinate)
            }
        }
    }

    func share() {
        let socialMetaTags = DynamicLinkSocialMetaTagParameters()
        socialMetaTags.imageURL = URL.init(string: cardDetails?.avatar?.sourceUrl ?? "")
        socialMetaTags.title = cardDetails?.company?.name
        socialMetaTags.descriptionText = cardDetails?.description
        view?.showShareSheet(path: .businessCard, parameters: [.id: "\(businessCardId)"], dynamicLinkSocialMetaTagParameters: socialMetaTags, successCompletion: { [weak self] in
            guard let self = self else { return }
            APIClient.default.incrementStatisticCount(cardID: self.businessCardId) { _ in }
        })
    }
    
    func save(completion: ((_ saved: Bool) -> Void)?) {
        switch cardDetails?.isSaved {
        case .none:
            break
        case .some(let value):
            switch value {
            case true:
                unsaveCard(completion: completion)
            case false:
                saveCard(completion: completion)
            }
        }
    }
    
    func expandDescription(at indexPath: IndexPath) {
        let descr = cardDetails?.description
        cardDetails?.descriptionToShow = descr
        cardDetails?.isDescriptionExpanded = true
        updateViewDataSource()
        view?.reload()
    }


}

// MARK: - Use cases

private extension BusinessCardDetailsPresenter {

    func saveCard(completion: ((_ saved: Bool) -> Void)?) {
        view?.startLoading()
        APIClient.default.addCardToFavourites(id: businessCardId) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.cardDetails?.isSaved = true
                self.view?.stopLoading(success: true, succesText: "SavedContent.cardSaved.message".localized, failureText: nil, completion: nil)
                NotificationCenter.default.post(name: .cardSaved,
                                                object: nil,
                                                userInfo: [Notification.Key.cardID: self.businessCardId, Notification.Key.controllerID: BusinessCardDetailsViewController.describing])
                completion?(true)
            case .failure:
                self.view?.stopLoading(success: false)
                completion?(false)
            }
        }
    }
    
    func unsaveCard(completion: ((_ saved: Bool) -> Void)?)  {
        view?.startLoading()
        APIClient.default.deleteCardFromFavourites(id: businessCardId) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.cardDetails?.isSaved = false
                self.view?.stopLoading(success: true, succesText: "SavedContent.cardUnsaved.message".localized, failureText: nil, completion: nil)
                NotificationCenter.default.post(name: .cardUnsaved,
                                                object: nil,
                                                userInfo: [Notification.Key.cardID: self.businessCardId, Notification.Key.controllerID: BusinessCardDetailsViewController.describing])
                completion?(false)
            case .failure:
                self.view?.stopLoading(success: false)
                completion?(true)
            }
        }
    }
    
    func fetchDataSource() {
        let group = DispatchGroup()
        var errors = [Error]()

        view?.startLoading(text: "Loading.loading.title".localized)

        // Fetch card details
        group.enter()
        APIClient.default.getCardInfo(id: businessCardId) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.cardDetails = response
                switch self.cardDetails?.description?.count ?? 0 {
                case 0..<Layout.maxCollapsedDescrCount:
                    self.cardDetails?.isDescriptionExpanded = true
                    self.cardDetails?.descriptionToShow = response?.description
                default:
                    self.cardDetails?.isDescriptionExpanded = false
                    self.cardDetails?.descriptionToShow = response?.description?
                        .prefix(Layout.maxCollapsedDescrCount)
                        .appending("...")
                }
                group.leave()
            case let .failure(error):
                errors.append(error)
                group.leave()
            }
        }

        // Fetch employeeList
        group.enter()
        APIClient.default.employeeList(cardId: businessCardId) { [weak self] (result) in
            switch result {
            case let .success(response):
                self?.employee = response?.compactMap { EmployeeModel(userId: $0.userId,
                                                                      cardId: $0.cardId,
                                                                      firstName: $0.firstName,
                                                                      lastName: $0.lastName,
                                                                      avatar: $0.avatar?.sourceUrl,
                                                                      position: $0.position,
                                                                      telephone: $0.telephone?.number,
                                                                      practiceType: PracticeModel(id: $0.practiceType?.id, title: $0.practiceType?.title)) } ?? []
                group.leave()
            case let .failure(error):
                errors.append(error)
                group.leave()
            }
        }

        // fetch services
        group.enter()
        APIClient.default.getServiceList(cardID: businessCardId) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.services = response?.compactMap { Service.PreviewModel(id: $0.id,
                                                                             name: $0.title,
                                                                             avatarPath: $0.avatar?.sourceUrl,
                                                                             price: $0.priceDetails ?? "Service.negotiablePrice.text".localized,
                                                                             descriptionTitle: $0.header,
                                                                             descriptionHeader: $0.description,
                                                                             contactTelephone: $0.contactTelephone?.number,
                                                                             contactEmail: $0.contactEmail?.address) } ?? []
                group.leave()
            case .failure(let error):
                errors.append(error)
                group.leave()
            }
        }

        // fetch albums list
        group.enter()
        APIClient.default.getAlbumsList(cardID: businessCardId) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.albumPreviewItems = response?.compactMap { PostPreview.Item.Model(albumID: $0.id,
                                                                                              title: $0.title,
                                                                                              avatarPath: $0.avatar?.sourceUrl,
                                                                                              avatarID: $0.avatar?.id) } ?? []
                group.leave()
            case .failure(let error):
                errors.append(error)
                group.leave()
            }
        }

        // fetch products
        group.enter()
        APIClient.default.getProductList(cardID: businessCardId) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                self?.products.removeAll()
                let previewItems = response?.compactMap { ProductPreviewItemModel(showroom: $0.showroom,
                                                                                  name: $0.title,
                                                                                  price: $0.price ?? "Service.negotiablePrice.text".localized,
                                                                                  image: $0.image?.sourceUrl,
                                                                                  productID: $0.id,
                                                                                  cardID: strongSelf.cardDetails?.id ?? -1,
                                                                                  companyName: strongSelf.cardDetails?.company?.name,
                                                                                  companyAvatar: strongSelf.cardDetails?.avatar?.sourceUrl,
                                                                                  isUserOwner: strongSelf.isUserOwner) } ?? []
                let groupedItems = Dictionary(grouping: previewItems, by: { $0.showroom })
                groupedItems.enumerated().forEach {
                    self?.products.append(ProductPreviewSectionModel(showroom: $0.element.key, headerTitle: "\("Service.showRoom.title".localized) \($0.element.key)", productPreviewItems: $0.element.value))
                }
                strongSelf.products.sort {
                    $0.showroom < $1.showroom
                }
                group.leave()
            case .failure(let error):
                errors.append(error)
                group.leave()
            }
        }
        
        // fetch feedbacks
        group.enter()
        APIClient.default.getFeedbackList(cardID: businessCardId, limit: 100, offset: 0) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.comments = response ?? []
                group.leave()
            case .failure(let error):
                errors.append(error)
                group.leave()
            }
        }

        // setup data source
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            /// Errors handling
            if !errors.isEmpty {
                errors.forEach {
                    strongSelf.view?.errorAlert(message: $0.localizedDescription)
                }
            }

            /// Datasource configuration
            strongSelf.view?.set(dataSource: strongSelf.dataSource)

            if strongSelf.isUserOwner {
                strongSelf.view?.setupEditCardView()
            } else {
                 strongSelf.view?.setupHideCardView()
            }

            strongSelf.updateViewDataSource()
            strongSelf.view?.reload()
        }
    }


}

// MARK: - Update data source

private extension BusinessCardDetailsPresenter {
    
    func updateViewDataSource() {
        
        /// Payment section
        dataSource?[.userHeader].items = []
        if isUserOwner {
            switch cardDetails?.subscriptionEndDate {
            case .none:
                dataSource?[.userHeader].items.append(
                    .publish(model: PublishCellModel(titleText: "Payment.status.notPublishedYet.title".localized,
                                                     subtitleText: "Payment.status.notPublishedYet.descr".localized,
                                                     actionTitle: "Payment.status.notPublishedYet.actionTitle".localized, action: { [weak self] in
                        guard let self = self else { return }
                        self.view?.businessCardPayment(cardID: self.businessCardId)
                    }))
                )
            case .some(let endDate):
                let currentDate = Date()
                if currentDate >= endDate {
                    dataSource?[.userHeader].items.append(
                        .publish(model: PublishCellModel(titleText: "Payment.status.expired.title".localized,
                                                         subtitleText: "Payment.status.expired.descr".localized,
                                                         actionTitle: "Payment.status.expired.actionTitle".localized, action: { [weak self] in
                                                            guard let self = self else { return }
                                                            self.view?.businessCardPayment(cardID: self.businessCardId)
                        }))
                    )
                } else {
                    let diffInDays = Calendar.current.dateComponents([.day], from: currentDate, to: endDate).day ?? 0
                    dataSource?[.userHeader].items.append(
                        .publish(model: PublishCellModel(titleText: "Payment.status.published.title".localized,
                                                         subtitleText: String(format: "Payment.status.published.descr".localized, diffInDays),
                                                         actionTitle: "Payment.status.published.actionTitle".localized, action: { [weak self] in
                            guard let self = self else { return }
                            self.view?.businessCardPayment(cardID: self.businessCardId)
                        }))
                    )
                }
            }
        }
        dataSource?[.userHeader].items.append(.userInfo(model: BusinessCardDetails.HeaderInfoModel(name: cardDetails?.company?.name,
                                                                                                   avatartImagePath: cardDetails?.avatar?.sourceUrl,
                                                                                                   bgimagePath: cardDetails?.background?.sourceUrl,
                                                                                                   profession: cardDetails?.practiceType?.title,
                                                                                                   telephoneNumber: cardDetails?.contactTelephone?.number,
                                                                                                   websiteAddress: cardDetails?.companyWebSite,
                                                                                                   isSaved: cardDetails?.isSaved ?? false)))
        /// Post preview section
        albumPreviewSection = PostPreview.Section(dataSourceID: BusinessCardDetails.PostPreviewDataSourceID.albumPreviews.rawValue, items: [])
        
        dataSource?[.postPreview].items.removeAll()
        dataSource?[.postPreview].items.append(.actionTitle(model: ActionTitleModel(title: "BusinessCard.section.createdAlbums.title".localized, counter: self.albumPreviewItems.count)))
        if isUserOwner {
            albumPreviewSection?.items.append(.add(title: "BusinessCard.createNewAlbum.text".localized, imagePath: cardDetails?.avatar?.sourceUrl))
        }
        albumPreviewSection?.items.append(contentsOf: albumPreviewItems.compactMap { PostPreview.Item.view($0) })
        if !(albumPreviewSection?.items.isEmpty ?? true) {
            dataSource?[.postPreview].items.append(.postPreview(model: albumPreviewSection))
        }

        /// card details section
        dataSource?[.cardDetails].items.removeAll()
        if let item = BusinessCardDetails.BarSectionsTypeIndex(rawValue: selectedBarItem.index) {
            switch item {
            case .general:
                if !(cardDetails?.attachments?.isEmpty ?? true) {
                    dataSource?[.cardDetails].items.append(
                        .photoCollage
                    )
                }
                
                /// Trimmed text
                let companyDescriptionModel = TitleDescrModel(title: cardDetails?.company?.name,
                                                              descr: cardDetails?.descriptionToShow,
                                                              isDescriptionExpanded: cardDetails?.isDescriptionExpanded ?? true)
                dataSource?[.cardDetails].items.append(
                    .companyDescription(model: companyDescriptionModel)
                )
                
                dataSource?[.cardDetails].items.append(
                    .getInTouch
                )
                dataSource?[.cardDetails].items.append(
                    .addressInfo(model: AddressInfoCellModel(mainAddress: cardDetails?.region?.name, subAdress: cardDetails?.city?.name, schedule: cardDetails?.schedule))
                )
                dataSource?[.cardDetails].items.append(
                    .map(centerPlaceID: cardDetails?.address?.googlePlaceId ?? "")
                )
                dataSource?[.cardDetails].items.append(
                    .mapDirection
                )
            case .contacts:
                dataSource?[.cardDetails].items.append(.contacts(model: ContactsModel(telNumber: cardDetails?.contactTelephone?.number, website: cardDetails?.companyWebSite, email: cardDetails?.contactEmail?.address)))
                dataSource?[.cardDetails].items.append(.getInTouch)

                let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
                if !listListItems.isEmpty {
                    dataSource?[.cardDetails].items.append(.title(text: "BusinessCard.section.socials.title".localized))
                    dataSource?[.cardDetails].items.append(.socialList)
                }

            case .team:
                let emplCells = employee.compactMap { BusinessCardDetails.Cell.employee(model: $0) }
                dataSource?[.cardDetails].items = emplCells

            case .services:
                if isUserOwner {
                    dataSource?[.cardDetails].items.append(.service(model: .add))
                }
                let previews: [BusinessCardDetails.Cell] = services.compactMap { BusinessCardDetails.Cell.service(model: .view(model: $0)) }
                dataSource?[.cardDetails].items.append(contentsOf: previews)

            case .products:
                if isUserOwner {
                    dataSource?[.cardDetails].items.append(.addProduct)
                }
                let previews: [BusinessCardDetails.Cell] = products.compactMap { BusinessCardDetails.Cell.productSection(model: $0) }
                dataSource?[.cardDetails].items.append(contentsOf: previews)
                
            case .responds:
                switch comments.isEmpty {
                case true:
                    dataSource?[.cardDetails].items = [
                        .commentPlaceholder(model: PlaceholderCellModel(image: UIImage(named: "ic_placeholder_comments"),
                                                                        title: "Feedback.placeholder.title".localized,
                                                                        subtitle: "Feedback.placeholder.subtitle".localized)),
                    ]
                case false:
                    dataSource?[.cardDetails].items = comments.compactMap {
                        BusinessCardDetails.Cell.comment(model: $0)
                    }
                }
                dataSource?[.cardDetails].items.append(
                    .button(model: ButtonCellModel(title: "Feedback.placeholder.leaveComment.normalTitle".localized, action: { [unowned self] in
                        self.view?.goToCreateFeedback(presenter: AddFeedbackPresenter(cardID: self.cardDetails?.id))
                    }
                )))
            }
        }
    }

    
}

// MARK: - HorizontalItemsBarViewDelegate

extension BusinessCardDetailsPresenter: HorizontalItemsBarViewDelegate {

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int) {
        if barItems[index].index == selectedBarItem.index {
            return
        }
        selectedBarItem = barItems[index]
        let insertionAnimation: UITableView.RowAnimation = index > selectedBarItem.index ? .left : .right
        let deletionAnimation: UITableView.RowAnimation = index < selectedBarItem.index ? .right : .left
        
        var deletionIndexPaths = [IndexPath]()
        for row in 0..<dataSource![.cardDetails].items.count {
            deletionIndexPaths.append(IndexPath(row: row, section: BusinessCardDetails.SectionAccessoryIndex.cardDetails.rawValue))
        }

        updateViewDataSource()

        var insertionIndexPaths = [IndexPath]()
        for row in 0..<dataSource![.cardDetails].items.count {
            insertionIndexPaths.append(IndexPath(row: row, section: BusinessCardDetails.SectionAccessoryIndex.cardDetails.rawValue))
        }

        self.view?.updateRows(insertion: insertionIndexPaths,
                              deletion: deletionIndexPaths,
                              insertionAnimation: insertionAnimation,
                              deletionAnimation: deletionAnimation)
    }


}

// MARK: - SocialsListTableViewCellDataSource

extension BusinessCardDetailsPresenter: SocialsListTableViewCellDataSource {

    var socials: [Social.ListItem] {
        get {
            let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
            return listListItems
        }
        set {}
    }


}

// MARK: - SocialsListTableViewCellDelegate

extension BusinessCardDetailsPresenter: SocialsListTableViewCellDelegate {

    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didSelectedSocialItem item: Social.ListItem) {
        switch item {
        case .view(let model):
            if let url = model.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                view?.errorAlert(message: "Error.Social.unreadableFormat".localized)
            }
        default:
            break
        }
    }

    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didLongPresseddOnItem value: Social.Model, at indexPath: IndexPath) {

    }


}

// MARK: - GetInTouchTableViewCellDelegate

extension BusinessCardDetailsPresenter: GetInTouchTableViewCellDelegate {

    func getInTouchTableViewCellDidOccuredCallAction(_ cell: GetInTouchTableViewCell) {
        view?.makeCall(to: cardDetails?.contactTelephone?.number)
    }

    func getInTouchTableViewCellDidOccuredEmailAction(_ cell: GetInTouchTableViewCell) {
        view?.sendEmail(to: cardDetails?.contactEmail?.address ?? "")
    }


}

// MARK: - ProductPreviewItemsHorizontalListDelegate

extension BusinessCardDetailsPresenter: ProductPreviewItemsHorizontalListDelegate {

    func productPreviewItemsHorizontalList(_ view: ProductPreviewItemsHorizontalListTableViewCell, didSelectItem item: ProductPreviewItemModel) {
        let presenter = ProductDetailsPresenter(productID: item.productID, cardID: item.cardID, companyName: item.companyName, companyAvatar: item.companyAvatar, isUserOwner: isUserOwner)
        self.view?.goToProductDetails(presenter: presenter)
    }


}

// MARK: - AlbumPreviewItemsViewDelegate, AlbumPreviewItemsViewDataSource

extension BusinessCardDetailsPresenter: AlbumPreviewItemsViewDelegate, AlbumPreviewItemsViewDataSource {

    func albumPreviewItemsView(_ view: AlbumPreviewItemsTableViewCell, didSelectedAt indexPath: IndexPath, dataSourceID: String?) {
        guard let id = dataSourceID, let dataSource = BusinessCardDetails.PostPreviewDataSourceID(rawValue: id) else {
            return
        }

        switch dataSource {
        case .albumPreviews:
            if let selectedItem = albumPreviewSection?.items[safe: indexPath.item] {
                switch selectedItem {
                case .add:
                    self.view?.goToCreatePost(cardID: businessCardId)
                case .view(let model):
                    let presenter = ArticleDetailsPresenter(albumID: model.albumID, articleID: model.articleID)
                    self.view?.goToArticleDetails(presenter: presenter)
                case .showMore:
                    break
                }
            }
        }
    }

    func albumPreviewItemsView(_ view: AlbumPreviewItemsTableViewCell, dataSourceID: String?) -> [PostPreview.Item] {
        guard let id = dataSourceID, let dataSource = BusinessCardDetails.PostPreviewDataSourceID(rawValue: id) else {
            return []
        }

        switch dataSource {
        case .albumPreviews:
            return albumPreviewSection?.items ?? []
        }
    }


}

// MARK: - PhotoCollageTableViewCellDataSource

extension BusinessCardDetailsPresenter: PhotoCollageTableViewCellDataSource {

    func photoCollage(_ view: PhotoCollageTableViewCell) -> [String?] {
        return cardDetails?.attachments?.compactMap { $0.sourceUrl } ?? []
    }


}

// MARK: - PhotoCollageTableViewCellDelegate

extension BusinessCardDetailsPresenter: PhotoCollageTableViewCellDelegate {

    func photoCollage(_ view: PhotoCollageTableViewCell, selectedPhotoAt index: Int) {
        let photos = cardDetails?.attachments?.compactMap { $0.sourceUrl } ?? []
        self.view?.openPhotoGallery(photos: photos, activedPhotoIndex: index)
    }


}
