//
//  ServiceDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 4/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation


protocol ServiceDetailsView: class, AlertDisplayableView, LoadDisplayableView, NavigableView, MessagingCallingView {
    func reload()
    func set(dataSource: TableDataSource<ServiceDetailsDataSourceConfigurator>?)
    func setupEmptyCardView()
    func setupEditCardView()

    func goToEditService(_ presenter: CreateServicePresenter?)
}

class ServiceDetailsPresenter: NSObject, BasePresenter {

    /// Managed view
    weak var view: ServiceDetailsView?

    // Data source
    private var serviceID: Int
    private var cardID: Int
    private var companyName: String?
    private var companyAvatar: String?
    private var isUserOwner: Bool

    private var details: Service.DetailsViewModel
    private var dataSource: TableDataSource<ServiceDetailsDataSourceConfigurator>?

    // MARK: - Object Life Cycle

    init(serviceID: Int, cardID: Int, companyName: String?, companyAvatar: String?, isUserOwner: Bool = false) {
        self.serviceID = serviceID
        self.cardID = cardID
        self.companyName = companyName
        self.companyAvatar = companyAvatar
        self.isUserOwner = isUserOwner
        self.details = Service.DetailsViewModel()

        super.init()
        self.dataSource = TableDataSource(configurator: dataSouceConfigurator)
        self.dataSource?.sections = [Section<Service.DetailsCell>(accessoryIndex: Service.DetailsSectionAccessoryIndex.header.rawValue, items: []),
                                     Section<Service.DetailsCell>(accessoryIndex: Service.DetailsSectionAccessoryIndex.description.rawValue, items: [])]
    }

    deinit {
        view = nil
    }

    // MARK: - Public

    func attachView(_ view: ServiceDetailsView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    func editService() {
        let detailsModel = Service.CreationDetailsModel(serviceID: details.id,
                                                        cardID: cardID,
                                                        photos: details.photos,
                                                        companyName: companyName,
                                                        companyAvatar: companyAvatar,
                                                        serviceName: details.title,
                                                        price: details.price,
                                                        isUseContactsFromSite: false,
                                                        telephoneNumber: details.telephoneNumber,
                                                        email: details.email,
                                                        isContractPrice: (details.price ?? "").isEmpty,
                                                        descriptionTitle: details.descriptionTitle,
                                                        desctiptionBody: details.desctiptionBody)

        let editServicePresenter = CreateServicePresenter(detailsModel: detailsModel)
        editServicePresenter.delegate = self
        view?.goToEditService(editServicePresenter)
    }

}

// MARK: - Use cases

extension ServiceDetailsPresenter {

    func fetchServiceDetails() {

        view?.startLoading()
        APIClient.default.getServiceDetails(serviceID: serviceID) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()
            switch result {
            case .success(let response):

                strongSelf.details = Service.DetailsViewModel(id: response?.id,
                                                              title: response?.title,
                                                              photos: response?.photos?.compactMap { EditablePhotoListItem.view(imagePath: $0.sourceUrl, imageID: $0.id) } ?? [],
                                                              companyName: strongSelf.companyName,
                                                              companyAvatar: strongSelf.companyAvatar,
                                                              serviceName: response?.title,
                                                              price: response?.priceDetails,
                                                              telephoneNumber: response?.contactTelephone?.number,
                                                              email: response?.contactEmail?.address,
                                                              descriptionTitle: response?.header,
                                                              desctiptionBody: response?.description)

                strongSelf.updateViewDataSource()
                strongSelf.view?.set(dataSource: strongSelf.dataSource)
                strongSelf.isUserOwner ? strongSelf.view?.setupEditCardView() : strongSelf.view?.setupEmptyCardView()
                strongSelf.view?.reload()

            case .failure(let error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }

        }

    }


}

// MARK: - Updating View Data Source

private extension ServiceDetailsPresenter {

    func updateViewDataSource() {

        dataSource?[Service.DetailsSectionAccessoryIndex.header].items = [
            .companyHeader(model: CompanyPreviewHeaderModel(title: details.companyName, image: details.companyAvatar)),
            .gallery,
            .serviceHeaderDescr(model: TitleDescrModel(title: details.title, descr: details.price ?? "Service.negotiablePrice.text".localized)),
            .getInTouch
        ]

        dataSource?[Service.DetailsSectionAccessoryIndex.description].items = [
            .sectionSeparator,
            .serviceDescription(model: TitleDescrModel(title: details.descriptionTitle, descr: details.desctiptionBody))
        ]

    }


}

// MARK: - HorizontalPhotosListDataSource

extension ServiceDetailsPresenter: HorizontalPhotosListDataSource {

    var photos: [EditablePhotoListItem] {
        get {
            return details.photos
        }
        set {
            details.photos = newValue
        }
    }


}

// MARK: - GetInTouchTableViewCellDelegate

extension ServiceDetailsPresenter: GetInTouchTableViewCellDelegate {

    func getInTouchTableViewCellDidOccuredCallAction(_ cell: GetInTouchTableViewCell) {
        view?.makeCall(to: details.telephoneNumber)
    }

    func getInTouchTableViewCellDidOccuredEmailAction(_ cell: GetInTouchTableViewCell) {
        view?.sendEmail(to: details.email ?? "")
    }


}

// MARK: - CreateServicePresenterDelegate

extension ServiceDetailsPresenter: CreateServicePresenterDelegate {

    func didUpdatedService(_ presenter: CreateServicePresenter) {
        fetchServiceDetails()
    }


}
