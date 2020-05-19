//
//  SettingsTableViewController.swift
//  CoBook
//
//  Created by protas on 5/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet var appVersionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        self.navigationItem.title = "Налаштування додатку"
    }

    func setupLayout() {

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let builsNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        appVersionLabel.text = "v\(appVersion ?? "0")(\(builsNumber ?? "0"))"
    }


}
