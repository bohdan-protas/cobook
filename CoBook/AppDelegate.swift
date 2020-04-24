//
//  AppDelegate.swift
//  CoBook
//
//  Created by protas on 2/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        /// Navigation Bar appearance
        UINavigationBar.appearance().backIndicatorImage = #imageLiteral(resourceName: "ic_arrow_back")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ic_arrow_back")
        UINavigationBar.appearance().tintColor = UIColor.Theme.blackMiddle
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = UIColor.Theme.grayBG

        // Tabbar appearance
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = UIColor.Theme.greenDark

        // UITabBarItem appearance
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.HelveticaNeueCyr_Black(size: 12)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.HelveticaNeueCyr_Black(size: 12)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.Theme.grayUI], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.Theme.greenDark], for: .selected)

        // IQKeyboard pod setup
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true
        IQKeyboardManager.shared.disabledToolbarClasses.append(ConfirmTelephoneNumberViewController.self)

        // Google services setup
        GMSServices.provideAPIKey(APIConstants.Google.placesApiKey)
        GMSPlacesClient.provideAPIKey(APIConstants.Google.placesApiKey)

        // App appearance setup
        /// Clear saved data in keychain if user reinstalled app
        if AppStorage.State.isFirstAppLaunch {
            AppStorage.deleteAllData()
            AppStorage.State.isFirstAppLaunch = false
        }

        if AppStorage.User.data?.userId == nil {
            if AppStorage.User.isTutorialShown {
                let signUpNavigationController: SignUpNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
                window?.rootViewController = signUpNavigationController
            } else {
                AppStorage.User.isTutorialShown = true
                let onboardingViewController: OnboardingViewController = UIStoryboard.auth.initiateViewControllerFromType()
                window?.rootViewController = onboardingViewController
            }
        } else {
            if AppStorage.Auth.refreshToken == nil {
                let signInNavigationController: SignInNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
                window?.rootViewController = signInNavigationController
            } else {
                window?.rootViewController = MainTabBarController()
            }
        }


        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if AppStorage.User.isUserInitiatedRegistration && !AppStorage.User.isUserCompletedRegistration {
            AppStorage.Auth.deleteAllData()
            AppStorage.User.data = nil
            AppStorage.User.isUserInitiatedRegistration = false
        }
    }


}

