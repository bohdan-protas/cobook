//
//  MainTabBarController.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let allCardsController: CardsOverviewNavigationController = UIStoryboard.allCards.initiateViewControllerFromType()
        allCardsController.tabBarItem = UITabBarItem(title: "Tabbar.allCards.title".localized, image: #imageLiteral(resourceName: "ic_tabbar_allcards_inactive"), selectedImage: #imageLiteral(resourceName: "ic_tabbar_allcards_active"))

        let savedContentController: SavedContentNavigationController = UIStoryboard.saved.initiateViewControllerFromType()
        savedContentController.tabBarItem = UITabBarItem(title: "Tabbar.saved.title".localized, image: #imageLiteral(resourceName: "ic_tabbar_saved_unactive"), selectedImage: #imageLiteral(resourceName: "ic_tabbar_saved_active"))

        let accountController: AccountNavigationController = UIStoryboard.account.initiateViewControllerFromType()
        accountController.tabBarItem = UITabBarItem(title: "Tabbar.account.title".localized, image: #imageLiteral(resourceName: "ic_tabbar_account_inactive"), selectedImage: #imageLiteral(resourceName: "ic_tabbar_account_active"))

        self.viewControllers = [allCardsController, savedContentController, accountController]
        self.selectedViewController = allCardsController

        // If pending dynamic link exists - its time to show it
        if let pendingDynamicLink = AppStorage.State.pendingDynamicLink {
            handleDynamicLink(pendingDynamicLink)
        }
    }

    // MARK: - Dynamic link handling

    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        // clear the current pending state url
        AppStorage.State.pendingDynamicLink = nil

        // regognize contoller to push from dynamic link
        if let recognizedController = DynamicLinkCoordinatorService().recognizeControllerFrom(dynamicLink: dynamicLink) {
             pushDynamicLink(recognizedController: recognizedController)
        } else {
            Log.error("Cannot recognize contoller from dynamic link: \(dynamicLink)")
        }
    }

    func handleDynamicLink(_ dynamicLink: DynamicLinkContainer) {
        // clear the current pending state url
        AppStorage.State.pendingDynamicLink = nil

        // regognize contoller to push from dynamic link
        if let recognizedController = DynamicLinkCoordinatorService().recognizeControllerFrom(dynamicLink: dynamicLink) {
            pushDynamicLink(recognizedController: recognizedController)
        } else {
            Log.error("Cannot recognize contoller from dynamic link: \(dynamicLink)")
        }
    }
    

}

// MARK: - Privates

private extension MainTabBarController {

    func pushDynamicLink(recognizedController: UIViewController) {
        let currentNavigationController = selectedViewController as? UINavigationController
        let currentControllersStack = currentNavigationController?.viewControllers
        if let rootController = currentControllersStack?.first {
            currentNavigationController?.setViewControllers([rootController, recognizedController], animated: true)
        } else {
            Log.error("Current dynamic links")
        }
    }

}
