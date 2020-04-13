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
    func configureDataSource(with configurator: BusinessCardDetailsDataSourceConfigurator)
    func updateDataSource(sections: [Section<BusinessCardDetails.Cell>])
    func sendEmail(to address: String)
    func openSettings()
}

class BusinessCardDetailsPresenter: NSObject, BasePresenter {

    private weak var view: BusinessCardDetailsView?

    private lazy var dataSourceConfigurator: BusinessCardDetailsDataSourceConfigurator = {
        let dataSourceConfigurator = BusinessCardDetailsDataSourceConfigurator(presenter: self)
        return dataSourceConfigurator
    }()

    private var businessCardId: Int
    private var cardDetails: CardDetailsApiModel?
    private var employee: [EmployeeModel] = []

    var items: [BarItemViewModel] {
        get {
            return [
                BarItemViewModel(index: 0, title: "Загальна\n інформація"),
                BarItemViewModel(index: 1, title: "Контакти"),
                BarItemViewModel(index: 2,title: "Команда"),
            ]
        }
    }


    var currentIndex: Int = 0 {
        didSet {
            updateViewDataSource()
        }
    }

    // MARK: - Object Lifecycle

    init(id: Int) {
        self.businessCardId = id
    }

    // MARK: - Public

    func attachView(_ view: BusinessCardDetailsView) {
        self.view = view
        self.view?.configureDataSource(with: dataSourceConfigurator)
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

        let userInfoSection = Section<BusinessCardDetails.Cell>(items: [
            .userInfo(model: BusinessCardDetails.HeaderInfoModel(name: cardDetails?.company?.name,
                                                                 avatartImagePath: cardDetails?.avatar?.sourceUrl,
                                                                 bgimagePath: cardDetails?.background?.sourceUrl,
                                                                 profession: cardDetails?.practiceType?.title,
                                                                 telephoneNumber: cardDetails?.contactTelephone?.number,
                                                                 websiteAddress: cardDetails?.companyWebSite)),
        ])

        var changableSection = Section<BusinessCardDetails.Cell>(items: [])
        switch currentIndex {
        case 0:
            changableSection.items = [.companyDescription(text: cardDetails?.description),
                                      .addressInfo(model: AddressInfoCellModel(mainAddress: cardDetails?.region?.name, subAdress: cardDetails?.city?.name, schedule: cardDetails?.schedule)),
                                      .map(path: ""),
                                      .mapDirection]
        case 1:
            let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
            if !listListItems.isEmpty {
                changableSection.items.append(.title(text: "Соціальні мережі:"))
                changableSection.items.append(.socialList)
            }
            changableSection.items.append(.getInTouch)
        case 2:
            let emplCells = employee.compactMap {
                BusinessCardDetails.Cell.employee(model: $0)
            }
            changableSection.items = emplCells
        default: break
        }

        view?.updateDataSource(sections: [userInfoSection, changableSection])
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
            }
        }
    }


}

// MARK: - HorizontalItemsBarViewDelegate

extension BusinessCardDetailsPresenter: HorizontalItemsBarViewDelegate {

    func horizontalItemsBarView(_ view: HorizontalItemsBarView, didSelectedItemAt index: Int) {
        currentIndex = index
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
