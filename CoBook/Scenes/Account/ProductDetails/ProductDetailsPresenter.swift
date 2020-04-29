//
//  ProductDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 4/29/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol ProductDetailsView: AlertDisplayableView, LoadDisplayableView, NavigableView, MessagingCallingView {
    func reload()
    func set(dataSource: DataSource<ProductDetailsDataSourceConfigurator>?)
    func setupEmptyCardView()
    func setupEditCardView()

    func goToEditService(_ presenter: CreateServicePresenter?)
}

class ProductDetailsPresenter: NSObject, BasePresenter {

    /// Managed view
    weak var view: ProductDetailsView?

    // Data source
    private var productID: Int
    private var cardID: Int
    private var companyName: String?
    private var companyAvatar: String?
    private var isUserOwner: Bool

    private var details: ProductDetails.DetailsModel
    private var dataSource: DataSource<ProductDetailsDataSourceConfigurator>?

    // MARK: - Object Life Cycle

    init(productID: Int, cardID: Int, companyName: String?, companyAvatar: String?, isUserOwner: Bool = false) {
        self.productID = productID
        self.cardID = cardID
        self.companyName = companyName
        self.companyAvatar = companyAvatar
        self.isUserOwner = isUserOwner
        self.details = ProductDetails.DetailsModel()

        super.init()
        self.dataSource = DataSource(configurator: dataSouceConfigurator)
        self.dataSource?.sections = [Section<ProductDetails.Cell>(accessoryIndex: ProductDetails.SectionAccessoryIndex.header.rawValue, items: []),
                                     Section<ProductDetails.Cell>(accessoryIndex: ProductDetails.SectionAccessoryIndex.description.rawValue, items: [])]
    }

    deinit {
        view = nil
    }

    // MARK: - Public

    func attachView(_ view: ProductDetailsView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

//    func editService() {
//        let detailsModel = Service.CreationDetailsModel(serviceID: details.id,
//                                                        cardID: cardID,
//                                                        photos: details.photos,
//                                                        companyName: companyName,
//                                                        companyAvatar: companyAvatar,
//                                                        serviceName: details.title,
//                                                        price: details.price,
//                                                        isUseContactsFromSite: false,
//                                                        telephoneNumber: details.telephoneNumber,
//                                                        email: details.email,
//                                                        isContractPrice: details.price == nil,
//                                                        descriptionTitle: details.descriptionTitle,
//                                                        desctiptionBody: details.desctiptionBody)
//
//        let editServicePresenter = CreateServicePresenter(detailsModel: detailsModel)
//        editServicePresenter.delegate = self
//        view?.goToEditService(editServicePresenter)
//    }

}

// MARK: - Use cases

extension ProductDetailsPresenter {

    func fetchProductDetails() {

        view?.startLoading()
        APIClient.default.getProductDetails(productID: productID) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()
            switch result {
            case .success(let response):

                strongSelf.details = ProductDetails.DetailsModel(id: response?.id,
                                                                 title: response?.title,
                                                                 showroom: response?.showroom,
                                                                 photos: response?.photos?.compactMap { EditablePhotoListItem.view(imagePath: $0.sourceUrl, imageID: $0.id) } ?? [],
                                                                 companyName: strongSelf.companyName,
                                                                 companyAvatar: strongSelf.companyAvatar,
                                                                 price: response?.priceDetails,
                                                                 telephoneNumber: response?.contactTelephone?.number,
                                                                 email: response?.contactEmail?.address,
                                                                 descriptionTitle: response?.header,
                                                                 desctiptionBody: response?.description)

                strongSelf.updateViewDataSource()
                strongSelf.view?.set(dataSource: strongSelf.dataSource)
                strongSelf.isUserOwner ? strongSelf.view?.setupEditCardView() : strongSelf.view?.setupEmptyCardView()
                strongSelf.view?.reload()

                break
            case .failure(let error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }


    }


}

// MARK: - Updating View Data Source

private extension ProductDetailsPresenter {

    func updateViewDataSource() {

        dataSource?[Service.DetailsSectionAccessoryIndex.header].items = [
            .companyHeader(model: CompanyPreviewHeaderModel(title: details.companyName, image: details.companyAvatar)),
            .gallery,
            .serviceHeaderDescr(model: TitleDescrModel(title: details.title, descr: details.price ?? "Ціна договірна")),
            .getInTouch
        ]

        dataSource?[Service.DetailsSectionAccessoryIndex.description].items = [
            .sectionSeparator,
            .serviceDescription(model: TitleDescrModel(title: details.descriptionTitle, descr: details.desctiptionBody))
        ]

    }


}

// MARK: - HorizontalPhotosListDataSource

extension ProductDetailsPresenter: HorizontalPhotosListDataSource {

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

extension ProductDetailsPresenter: GetInTouchTableViewCellDelegate {

    func getInTouchTableViewCellDidOccuredCallAction(_ cell: GetInTouchTableViewCell) {
        view?.makeCall(to: details.telephoneNumber)
    }

    func getInTouchTableViewCellDidOccuredEmailAction(_ cell: GetInTouchTableViewCell) {
        view?.sendEmail(to: details.email ?? "")
    }


}



