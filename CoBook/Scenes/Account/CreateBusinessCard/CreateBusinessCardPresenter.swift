//
//  CreateBusinessCardPresenter.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GooglePlaces

protocol CreateBusinessCardView: AlertDisplayableView, LoadDisplayableView, NavigableView {
    var tableView: UITableView! { get set }
    func showAutocompleteController(filter: GMSAutocompleteFilter, completion: ((GMSPlace) -> Void)?)
    func setSaveButtonEnabled(_ isEnabled: Bool)
    func setupHeaderFooterViews()
}

class CreateBusinessCardPresenter: NSObject, BasePresenter {

    enum Defaults {
        static let imageCompressionQuality: CGFloat = 0.1
    }

    // MARK: Properties
    private weak var view: CreateBusinessCardView?
    private var viewDataSource: CreateBusinessCardViewDataSource?

    private var businessCardParameters: CardAPIModel.BusinessCardParameters {
        didSet {
        }
    }

    // MARK: Lifecycle
    init(parameters: CardAPIModel.BusinessCardParameters? = nil) {
        self.businessCardParameters = parameters ?? CardAPIModel.BusinessCardParameters()
    }

    // MARK: Public
    func attachView(_ view: CreateBusinessCardView) {
        self.view = view
        self.viewDataSource = CreateBusinessCardViewDataSource(tableView: view.tableView)
    }

    func detachView() {
        view = nil
        viewDataSource = nil
    }

    func onViewDidLoad() {
        
    }

    func createBusinessCard() {

    }

}

// MARK: - CreatePersonalCardPresenter
private extension CreateBusinessCardPresenter {

    func setupDataSource() {
        view?.setupHeaderFooterViews()
        //viewDataSource?.cellsDelegate = self

        syncDataSource()
        viewDataSource?.tableView.reloadData()
    }

    func syncDataSource() {

//        viewDataSource?.source = [
//            CreatePersonalCard.Section(items: [
//                .avatarPhotoManagment(sourceType: .personalCard, imagePath: personalCardParameters.avatarUrl),
//                .sectionHeader,
//                .title(text: "Діяльність:"),
//                .textField(text: personalCardParameters.position, type: .occupiedPosition),
//                .actionTextField(text: personalCardParameters.practiseType.title, type: .activityType(list: personalCardParameters.practices)),
//                .actionTextField(text: personalCardParameters.city.name, type: .placeOfLiving),
//                .actionTextField(text: personalCardParameters.region.name, type: .activityRegion),
//                .textView(text: personalCardParameters.description, type: .activityDescription)
//            ]),
//            CreatePersonalCard.Section(items: [
//                .sectionHeader,
//                .title(text: "Контактні дані:"),
//                .textField(text: personalCardParameters.contactEmail, type: .workingEmailForCommunication),
//                .textField(text: personalCardParameters.contactTelephone, type: .workingPhoneNumber),
//                .title(text: "Соціальні мережі:"),
//                .socialList(list: personalCardParameters.socialNetworks)
//            ]),
//            CreatePersonalCard.Section(items: [
//                .sectionHeader,
//                .title(text: "Інтереси (для рекомендацій)"),
//                .interests(list: personalCardParameters.interests)
//            ])
//        ]
    }

    func fetchDataSource() {
        let group = DispatchGroup()

        var practicesTypesListRequestError: Error?
        var interestsListRequestError: Error?

        view?.startLoading(text: "Завантаження")

        // fetch practices
        group.enter()
        APIClient.default.practicesTypesListRequest { [weak self] (result) in
            guard let strongSelf = self else { return }

            switch result {
            case let .success(response):
                strongSelf.businessCardParameters.practices = (response ?? []).map { Card.PracticeItem(id: $0.id, title: $0.title) }
                group.leave()
            case let .failure(error):
                practicesTypesListRequestError = error
                group.leave()
            }
        }

        // fetch interests
        group.enter()
        APIClient.default.interestsListRequest { [weak self] (result) in
            guard let strongSelf = self else { return }

            switch result {
            case let .success(response):
                let currentSelectedInterests = strongSelf.businessCardParameters.interests
                let fetchedInterests: [Card.InterestItem] = (response ?? []).compactMap { fetched in
                    let isSelected = currentSelectedInterests.contains(where: { (selected) -> Bool in
                        return selected.id == fetched.id
                    })
                    return Card.InterestItem(id: fetched.id, title: fetched.title, isSelected: isSelected)
                }

                strongSelf.businessCardParameters.interests = fetchedInterests
                group.leave()
            case let .failure(error):
                interestsListRequestError = error
                group.leave()
            }
        }

        // setup data source
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view?.stopLoading()

            if practicesTypesListRequestError != nil {
                strongSelf.view?.errorAlert(message: practicesTypesListRequestError?.localizedDescription)
                return
            }

            if interestsListRequestError != nil  {
                strongSelf.view?.errorAlert(message: interestsListRequestError?.localizedDescription)
            }

            strongSelf.setupDataSource()
        }
    }

}
