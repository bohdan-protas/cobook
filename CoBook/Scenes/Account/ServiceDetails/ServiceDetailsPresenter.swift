//
//  ServiceDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 4/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation


protocol ServiceDetailsView: AlertDisplayableView, LoadDisplayableView, NavigableView, MessagingCallingView {
    func reload()
    func set(dataSource: DataSource<ServiceDetailsDataSourceConfigurator>?)
    func setupEmptyCardView()
    func setupEditCardView()
}

class ServiceDetailsPresenter: NSObject, BasePresenter {

    /// Managed view
    weak var view: ServiceDetailsView?

    // Data source
    private var details: Service.DetailsViewModel
    private var dataSource: DataSource<ServiceDetailsDataSourceConfigurator>?

    // MARK: - Object Life Cycle

    init(serviceID: Int, cardID: Int) {
        self.details = Service.DetailsViewModel(serviceID: serviceID, cardID: cardID)

        super.init()
        self.dataSource = DataSource(configurator: dataSouceConfigurator)
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

    func onViewDidLoad() {
        updateViewDataSource()
        view?.set(dataSource: dataSource)
        view?.setupEditCardView()
        view?.reload()
    }

}

// MARK: - Use cases

extension ServiceDetailsPresenter {



}

// MARK: - Updating View Data Source

private extension ServiceDetailsPresenter {

    func updateViewDataSource() {

        dataSource?[Service.DetailsSectionAccessoryIndex.header].items = [
            .companyHeader(model: CompanyPreviewHeaderModel(title: details.companyName, image: details.companyAvatar)),
            .gallery,
            .sectionSeparator,
            .getInTouch
        ]

        dataSource?[Service.DetailsSectionAccessoryIndex.description].items = [

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
