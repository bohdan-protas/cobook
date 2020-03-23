//
//  PersonalCardDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 3/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol PersonalCardDetailsView: AlertDisplayableView, LoadDisplayableView, NavigableView {
    var tableView: UITableView! { get set }
    func setupHeaderFooterViews()
    func sendEmail(to address: String)
}

class PersonalCardDetailsPresenter: NSObject, BasePresenter {

    // MARK: Properties
    private weak var view: PersonalCardDetailsView?
    private var viewDataSource: PersonalCardDetailsDataSource?

    private var personalCardId: Int
    private var cardDetails: CardAPIModel.CardDetailsAPIResponseData?

    // MARK: Lifecycle
    init(id: Int) {
        self.personalCardId = id
    }

    // MARK: Public
    func attachView(_ view: PersonalCardDetailsView) {
        self.view = view
        self.viewDataSource = PersonalCardDetailsDataSource(tableView: view.tableView)
        self.viewDataSource?.cellsDelegate = self
    }

    func detachView() {
        view = nil
        viewDataSource = nil
    }

    func onViewDidLoad() {
        setupDataSource()
    }

    func editPerconalCard() {
        let createPersonalCardViewController: CreatePersonalCardViewController = UIStoryboard.account.initiateViewControllerFromType()
        if let cardDetails = cardDetails {
            createPersonalCardViewController.presenter = CreatePersonalCardPresenter(parameters: CardAPIModel.PersonalCardParameters(with: cardDetails))
        } else {
            createPersonalCardViewController.presenter = CreatePersonalCardPresenter()
        }
        view?.push(controller: createPersonalCardViewController, animated: true)
    }
    

}

// MARK: - PersonalCardDetailsPresenter
private extension PersonalCardDetailsPresenter {

    func setupDataSource() {
        view?.startLoading()
        APIClient.default.getCardInfo(id: personalCardId) { [weak self] (result) in
            self?.view?.stopLoading()

            switch result {
            case let .success(response):
                self?.cardDetails = response
                self?.view?.setupHeaderFooterViews()
                self?.syncViewDataSource()
                self?.view?.tableView.reloadData()
            case let .failure(error):
                self?.view?.errorAlert(message: error.localizedDescription, handler: { (_) in
                    self?.view?.popController()
                })
            }
        }
    }

    func syncViewDataSource() {
        let userInfoSection = PersonalCardDetails.Section(useHeader: false, items: [
            .userInfo(model: cardDetails)
        ])

        var getInTouchSection =  PersonalCardDetails.Section(items: [
            .title(text: "Зв’язатись:"),
        ])

        let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
        if !listListItems.isEmpty {
            getInTouchSection.items.append(.socialList(list: listListItems))
        }
        getInTouchSection.items.append(.getInTouch)

        viewDataSource?.source = [
            userInfoSection, getInTouchSection
        ]

    }


}

// MARK: - SocialsListTableViewCellDelegate
extension PersonalCardDetailsPresenter: SocialsListTableViewCellDelegate {

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
extension PersonalCardDetailsPresenter: GetInTouchTableViewCellDelegate {

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

