//
//  SettingsTableViewController.swift
//  CoBook
//
//  Created by protas on 5/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @Localized("Settings.item.updateAccount.title")
    @IBOutlet var updateAccountTitleLabel: UILabel!

    @Localized("Settings.item.changePassword.title")
    @IBOutlet var changePasswordLabel: UILabel!

    @Localized("Settings.item.paymentMethods.title")
    @IBOutlet var paymentMethodsLabel: UILabel!

    @Localized("Settings.item.rules.title")
    @IBOutlet var rulesTitleLabel: UILabel!

    @Localized("Settings.item.secureConditions.title")
    @IBOutlet var secureConditionsTitleLabel: UILabel!

    @Localized("Settings.item.appVersion.title")
    @IBOutlet var appVersionTitleLabel: UILabel!

    @IBOutlet var appVersionDetailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        self.navigationItem.title = "Settings.title".localized
    }

    func setupLayout() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let builsNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        appVersionDetailLabel.text = "\(appVersion ?? "0")(\(builsNumber ?? "0"))"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 2:
            UIApplication.shared.open(Constants.CoBook.licenseURL)
        case 3:
            UIApplication.shared.open(Constants.CoBook.privacyPolicyURL)
        default:
            break
        }
    }

}
