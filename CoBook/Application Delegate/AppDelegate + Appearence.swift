//
//  AppDelegate + Appearence.swift
//  CoBook
//
//  Created by Bogdan Protas on 21.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func setupAppearence() {
        UINavigationBar.appearance().tintColor = UIColor.Theme.blackMiddle
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.SFProDisplay_Medium(size: 26), .foregroundColor: UIColor.Theme.blackMiddle]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = UIColor.Theme.grayBG

        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = UIColor.Theme.greenDark

        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle.withAlphaComponent(0.5)], for: .disabled)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle.withAlphaComponent(0.5)], for: .highlighted)

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.HelveticaNeueCyr_Black(size: 12)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.HelveticaNeueCyr_Black(size: 12)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.Theme.grayUI], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.Theme.greenDark], for: .selected)
    }
    
    func setupScreenToOpen(on window: UIWindow?) {
        
        if AppStorage.User.Profile?.userId == nil {
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
    }
    
}
