//
//  BusinessCardDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GoogleMaps

protocol BusinessCardDetailsView: AlertDisplayableView, LoadDisplayableView, NavigableView {

    func set(dataSource: DataSource<BusinessCardDetailsDataSourceConfigurator>?)
    func reload(section: BusinessCardDetails.SectionAccessoryIndex)
    func reload()

    func setupEditCardView()
    func setupHideCardView()

    func sendEmail(to address: String)
    func openSettings()
}

class BusinessCardDetailsPresenter: NSObject, BasePresenter {

    /// Managed view
    weak var view: BusinessCardDetailsView?

    /// bar items busienss logic
    var barItems: [BarItemViewModel]
    var selectedBarItem: BarItemViewModel?

    /// Business logic datasource
    private var businessCardId: Int
    private var cardDetails: CardDetailsApiModel?
    private var employee: [EmployeeModel] = []

    /// View datasource
    private var dataSource: DataSource<BusinessCardDetailsDataSourceConfigurator>?

    // MARK: - Object Lifecycle

    init(id: Int) {
        self.businessCardId = id
        self.barItems = [
            BarItemViewModel(index: BusinessCardDetails.BarSectionsTypeIndex.general.rawValue, title: "Загальна\n інформація"),
            BarItemViewModel(index: BusinessCardDetails.BarSectionsTypeIndex.contacts.rawValue, title: "Контакти"),
            BarItemViewModel(index: BusinessCardDetails.BarSectionsTypeIndex.team.rawValue, title: "Команда"),
        ]
        self.selectedBarItem = barItems.first

        super.init()
        
        self.dataSource = DataSource(configurator: dataSouceConfigurator)
        self.dataSource?.sections = [Section<BusinessCardDetails.Cell>(accessoryIndex: BusinessCardDetails.SectionAccessoryIndex.userHeader.rawValue, items: []),
                                     Section<BusinessCardDetails.Cell>(accessoryIndex: BusinessCardDetails.SectionAccessoryIndex.cardDetails.rawValue, items: [])]
    }

    // MARK: - Public

    func attachView(_ view: BusinessCardDetailsView) {
        self.view = view
        view.set(dataSource: dataSource)
    }

    func detachView() {
        view = nil
    }

    func onViewDidLoad() {

    }

    func onViewWillAppear() {
        setupDataSource()
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


}

// MARK: - Privates

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
        if let item = BusinessCardDetails.BarSectionsTypeIndex(rawValue: selectedBarItem?.index ?? -1) {
            switch item {
            case .general:
                dataSource?[.cardDetails].items = [.companyDescription(text: cardDetails?.description),
                                                   .addressInfo(model: AddressInfoCellModel(mainAddress: cardDetails?.region?.name, subAdress: cardDetails?.city?.name, schedule: cardDetails?.schedule)),
                                                   .map(path: ""),
                                                   .mapDirection]
            case .contacts:
                let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
                if !listListItems.isEmpty {
                    dataSource?[.cardDetails].items.append(.title(text: "Соціальні мережі:"))
                    dataSource?[.cardDetails].items.append(.socialList)
                }
                dataSource?[.cardDetails].items.append(.getInTouch)
            case .team:
                let emplCells = employee.compactMap {
                    BusinessCardDetails.Cell.employee(model: $0)
                }
                dataSource?[.cardDetails].items = emplCells
            }
        }
    }


}

// MARK: - Use cases

private extension BusinessCardDetailsPresenter {

    func setupDataSource() {
        let group = DispatchGroup()
        var errors = [Error]()

        var cardDetails: CardDetailsApiModel?
        var employee: [EmployApiModel] = []

        view?.startLoading(text: "Завантаження")

        group.enter()
        APIClient.default.getCardInfo(id: businessCardId) { (result) in
            switch result {
            case let .success(response):
                cardDetails = response
                group.leave()
            case let .failure(error):
                errors.append(error)
                group.leave()
            }
        }

        group.enter()
        APIClient.default.employeeList(cardId: businessCardId) { (result) in
            switch result {
            case let .success(response):
                employee = response ?? []
                group.leave()
            case let .failure(error):
                errors.append(error)
                group.leave()
            }
        }

        // setup data source
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            if !errors.isEmpty {
                errors.forEach {
                    self?.view?.errorAlert(message: $0.localizedDescription)
                }
            } else {
                self?.cardDetails = cardDetails
                self?.employee = employee.map { EmployeeModel(userId: $0.userId,
                                                              cardId: $0.cardId,
                                                              firstName: $0.firstName,
                                                              lastName: $0.lastName,
                                                              avatar: $0.avatar?.sourceUrl,
                                                              position: $0.position,
                                                              telephone: $0.telephone?.number,
                                                              practiceType: PracticeModel(id: $0.practiceType?.id, title: $0.practiceType?.title)) }
                self?.updateViewDataSource()
                self?.view?.setupEditCardView()
                self?.view?.reload()
            }
        }
    }


}

// MARK: - HorizontalItemsBarViewDelegate

extension BusinessCardDetailsPresenter: HorizontalItemsBarViewDelegate {

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int) {
        selectedBarItem = barItems[safe: index]
        updateViewDataSource()
        self.view?.reload(section: .cardDetails)
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
        guard let number = cardDetails?.contactTelephone?.number, let numberUrl = URL(string: "tel://" + number) else {
            view?.errorAlert(message: "Telephone number of user have bad format")
            return
        }
        UIApplication.shared.open(numberUrl, options: [:], completionHandler: nil)
    }

    func getInTouchTableViewCellDidOccuredEmailAction(_ cell: GetInTouchTableViewCell) {
        view?.sendEmail(to: cardDetails?.contactEmail?.address ?? "")
    }


}

// MARK: - MapTableViewCellDelegate

extension BusinessCardDetailsPresenter: MapTableViewCellDelegate {

    func openSettingsAction(_ cell: MapTableViewCell) {
        view?.openSettings()
    }


}
