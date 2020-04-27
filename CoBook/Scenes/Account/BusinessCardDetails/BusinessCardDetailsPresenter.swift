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

protocol BusinessCardDetailsView: AlertDisplayableView, LoadDisplayableView, NavigableView, MessagingCallingView, MapDirectionTableViewCellDelegate {
    func set(dataSource: DataSource<BusinessCardDetailsDataSourceConfigurator>?)
    func reload(section: BusinessCardDetails.SectionAccessoryIndex, animation: UITableView.RowAnimation)
    func reload()
    func setupEditCardView()
    func setupHideCardView()
    func updateRows(insertion: [IndexPath], deletion: [IndexPath], insertionAnimation: UITableView.RowAnimation, deletionAnimation: UITableView.RowAnimation)

    func goToCreateService(presenter: CreateServicePresenter?)
}

class BusinessCardDetailsPresenter: NSObject, BasePresenter {

    /// Managed view
    weak var view: BusinessCardDetailsView?

    /// bar items busienss logic
    var barItems: [BarItem]
    var selectedBarItem: BarItem

    /// Datasource
    private var businessCardId: Int
    private var cardDetails: CardDetailsApiModel?
    private var employee: [EmployeeModel] = []
    private var services: [Service.PreviewModel] = []

    /// View datasource
    private var dataSource: DataSource<BusinessCardDetailsDataSourceConfigurator>?

    /// Flag for owner identifire
    private var isUserOwner: Bool {
        return AppStorage.User.data?.userId == cardDetails?.cardCreator?.id
    }

    // MARK: - Object Lifecycle

    init(id: Int) {
        self.businessCardId = id
        self.barItems = [
            BarItem(index: BusinessCardDetails.BarSectionsTypeIndex.general.rawValue, title: "Загальна\n інформація"),
            BarItem(index: BusinessCardDetails.BarSectionsTypeIndex.services.rawValue, title: "Послуги"),
            BarItem(index: BusinessCardDetails.BarSectionsTypeIndex.contacts.rawValue, title: "Контакти"),
            BarItem(index: BusinessCardDetails.BarSectionsTypeIndex.team.rawValue, title: "Команда"),
        ]
        self.selectedBarItem = barItems.first!

        super.init()
        
        self.dataSource = DataSource(configurator: dataSouceConfigurator)
        self.dataSource?.sections = [Section<BusinessCardDetails.Cell>(accessoryIndex: BusinessCardDetails.SectionAccessoryIndex.userHeader.rawValue, items: []),
                                     Section<BusinessCardDetails.Cell>(accessoryIndex: BusinessCardDetails.SectionAccessoryIndex.cardDetails.rawValue, items: [])]
    }

    // MARK: - Public

    func attachView(_ view: BusinessCardDetailsView) {
        self.view = view

    }

    func detachView() {
        view = nil
    }

    func onViewDidLoad() {

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
        case .employee(let model):
            // TODO: - Add segue to card details VC
            break
        case .service(let model):
            switch model {
            case .view(let model): break
            case .add:
                let presenter = CreateServicePresenter(businessCardID: businessCardId, companyName: cardDetails?.company?.name, companyAvatar: cardDetails?.avatar?.sourceUrl)
                view?.goToCreateService(presenter: presenter)
            }
        default:
            break
        }
    }

    func getRouteDestination(callback: ((CLLocationCoordinate2D?) -> Void)?) {
        guard let addressId = self.cardDetails?.address?.googlePlaceId else {
            view?.errorAlert(message: "Невизначений адрес призначення маршруту")
            return
        }

        GMSPlacesClient.shared().fetchPlace(fromPlaceID: addressId, placeFields: .all, sessionToken: nil) { [unowned self] (place, error) in
            DispatchQueue.main.async {
                if error != nil {
                    let errorDescr = error?.localizedDescription ?? "Невизначений адрес призначення маршруту"
                    self.view?.errorAlert(message: errorDescr)
                }
                callback?(place?.coordinate)
            }
        }
    }


}

// MARK: - Use cases

private extension BusinessCardDetailsPresenter {

    func fetchDataSource() {
        let group = DispatchGroup()
        var errors = [Error]()

        view?.startLoading(text: "Завантаження")

        // Fetch card details
        group.enter()
        APIClient.default.getCardInfo(id: businessCardId) { [weak self] (result) in
            group.leave()
            switch result {
            case let .success(response):
                self?.cardDetails = response
            case let .failure(error):
                errors.append(error)
            }
        }

        // Fetch employeeList
        group.enter()
        APIClient.default.employeeList(cardId: businessCardId) { [weak self] (result) in
            group.leave()
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
            case let .failure(error):
                errors.append(error)
            }
        }

        // Fetch Services list
        group.enter()
        APIClient.default.getServiceList(cardID: businessCardId) { [weak self] (result) in
            group.leave()
            switch result {
            case .success(let response):

                self?.services = response?.compactMap { Service.PreviewModel(id: $0.id,
                                                                             name: $0.title,
                                                                             avatarPath: $0.avatar?.sourceUrl,
                                                                             price: $0.priceDetails ?? "Ціна договірна",
                                                                             descriptionTitle: $0.header,
                                                                             descriptionHeader: $0.description,
                                                                             contactTelephone: $0.contactTelephone?.number,
                                                                             contactEmail: $0.contactEmail?.address) } ?? []
            case .failure(let error):
                errors.append(error)
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

        dataSource?[.userHeader].items = [
                    .userInfo(model: BusinessCardDetails.HeaderInfoModel(name: cardDetails?.company?.name,
                                                                         avatartImagePath: cardDetails?.avatar?.sourceUrl,
                                                                         bgimagePath: cardDetails?.background?.sourceUrl,
                                                                         profession: cardDetails?.practiceType?.title,
                                                                         telephoneNumber: cardDetails?.contactTelephone?.number,
                                                                         websiteAddress: cardDetails?.companyWebSite))
        ]
        dataSource?[.cardDetails].items.removeAll()
        if let item = BusinessCardDetails.BarSectionsTypeIndex(rawValue: selectedBarItem.index) {
            switch item {
            case .general:
                dataSource?[.cardDetails].items = [.companyDescription(text: cardDetails?.description),
                                                   .getInTouch,
                                                   .addressInfo(model: AddressInfoCellModel(mainAddress: cardDetails?.region?.name, subAdress: cardDetails?.city?.name, schedule: cardDetails?.schedule)),
                                                   .map(centerPlaceID: cardDetails?.address?.googlePlaceId ?? ""),
                                                   .mapDirection]
            case .contacts:
                dataSource?[.cardDetails].items.append(.contacts(model: ContactsModel(telNumber: cardDetails?.contactTelephone?.number, website: cardDetails?.companyWebSite, email: cardDetails?.contactEmail?.address)))
                dataSource?[.cardDetails].items.append(.getInTouch)

                let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
                if !listListItems.isEmpty {
                    dataSource?[.cardDetails].items.append(.title(text: "Соціальні мережі:"))
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
            }
        }
    }


}



// MARK: - HorizontalItemsBarViewDelegate

extension BusinessCardDetailsPresenter: HorizontalItemsBarViewDelegate {

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int) {
        if index == selectedBarItem.index {
            return
        }

        let insertionAnimation: UITableView.RowAnimation = index > selectedBarItem.index ? .left : .right
        let deletionAnimation: UITableView.RowAnimation = index > selectedBarItem.index ? .right : .left

        var deletionIndexPaths = [IndexPath]()
        var insertionIndexPaths = [IndexPath]()

        for row in 0..<dataSource![.cardDetails].items.count {
            deletionIndexPaths.append(IndexPath(row: row, section: BusinessCardDetails.SectionAccessoryIndex.cardDetails.rawValue))
        }

        selectedBarItem = barItems[index]
        updateViewDataSource()

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
                view?.errorAlert(message: "Посилання соцмережі має нечитабельний формат")
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
