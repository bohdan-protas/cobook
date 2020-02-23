//
//  OnboardingPresenter.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol OnboardingView: UIViewController, BaseView {
    var presenter: OnboardingPresenter { get set }
    func scrollToItem(at indexPath: IndexPath)
    func goToSignUp()
    func page(for cell: UICollectionViewCell) -> Int?
}

class OnboardingPresenter: BasePresenter {

    // MARK: Properties
    private weak var view: OnboardingView?
    private var dataManager: OnboardingDataManager

    // MARK: Public
    init(dataManager: OnboardingDataManager) {
        self.dataManager = dataManager
        self.dataManager.delegate = self

        dataManager.dataSource = [
            Onboarding.PageModel(title: "Onboarding.Title01".localized,
                                 subtitle: "Onboarding.Subtitle01".localized,
                                 image: UIImage(named: "ic_businessman"),
                                 actionTitle: "Onboarding.Next".localized,
                                 action: Onboarding.ButtonActionType.next),

            Onboarding.PageModel(title: "Onboarding.Title02".localized,
                                 subtitle: "Onboarding.Subtitle02".localized,
                                 image: UIImage(named: "ic_business_plan"),
                                 actionTitle: "Onboarding.Next".localized,
                                 action: Onboarding.ButtonActionType.next),

            Onboarding.PageModel(title: "Onboarding.Title03".localized,
                                 subtitle: "Onboarding.Subtitle03".localized,
                                 image: UIImage(named: "ic_business_deal"),
                                 actionTitle: "Onboarding.Start".localized,
                                 action: Onboarding.ButtonActionType.finish)
        ]
    }

    /// base presenter
    func attachView(_ view: OnboardingView) { self.view = view }
    func detachView() { view = nil }
}

extension OnboardingPresenter: OnboardingPageCollectionViewCellDelegate {
    func actionButtonDidTapped(_ cell: OnboardingPageCollectionViewCell, actionType: Onboarding.ButtonActionType?) {
        guard let action = actionType else {
            return
        }

        switch action {
        case .next:
            guard let page = view?.page(for: cell) else {
                return
            }
            let nextIndexPath = IndexPath(item: page+1, section: 0)
            view?.scrollToItem(at: nextIndexPath)
        case .finish:
            view?.goToSignUp()
        }
    }
}
