//
//  AppDelegate.swift
//  CoBook
//
//  Created by protas on 2/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

        if AppStorage.isUserCompletedTutorial {
            let signUpNavigationController: SignUpNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
            window?.rootViewController = signUpNavigationController
        } else {
            let onboardingViewController: OnboardingViewController = UIStoryboard.auth.initiateViewControllerFromType()
            window?.rootViewController = onboardingViewController
        }

        window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if AppStorage.isUserInitiatedRegistration && !AppStorage.isUserCompletedRegistration {
            AppStorage.accessToken = nil
            AppStorage.refreshToken = nil
            AppStorage.profile = nil
            AppStorage.isUserInitiatedRegistration = false
        }
    }


}

