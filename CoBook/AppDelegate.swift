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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        if AppStorage.State.isFirstAppLaunch {
            AppStorage.deleteAllData()
            AppStorage.State.isFirstAppLaunch = false
        }

        IQKeyboardManager.shared.enable = true
        GMSPlacesClient.provideAPIKey(APIConstants.Google.placesApiKey)

        if AppStorage.User.profile?.userId == nil {
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
                let signInViewController: SignInViewController = UIStoryboard.auth.initiateViewControllerFromType()
                window?.rootViewController = signInViewController
            } else {
                window?.rootViewController = MainTabBarController()
            }
        }


        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if AppStorage.User.isUserInitiatedRegistration && !AppStorage.User.isUserCompletedRegistration {
            AppStorage.Auth.accessToken = nil
            AppStorage.Auth.refreshToken = nil
            AppStorage.User.profile = nil
            AppStorage.User.isUserInitiatedRegistration = false
        }
    }


}

