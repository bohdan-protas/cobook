//
//  AlertDisplayableView.swift
//  CoBook
//
//  Created by protas on 2/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol AlertDisplayableView {
    func defaultErrorAlert()

    func errorAlert(message: String?)
    func errorAlert(message: String?, handler: ((UIAlertAction) -> Void)?)

    func infoAlert(title: String?, message: String?)
    func infoAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)?)

    func actionSheetAlert(title: String?, message: String?, actions: [UIAlertAction])
    func newSocialAlert(name: String?, link: String?, completion: ((_ name: String?, _ url: String?) -> Void)?)

    func newFolderAlert(folderName: String?, completion: ((_ name: String) -> Void)?)
    func openSettingsAlert()
}

extension AlertDisplayableView where Self: UIViewController {

    func openSettingsAlert() {
        let alertController = UIAlertController (title: nil, message: "Перейти в налаштування?", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Налаштування", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }

        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Відмінити", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func infoAlert(title: String? = "", message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localized, style: .default, handler: handler)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func errorAlert(message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "Error".localized, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localized, style: .default, handler: handler)
        alertController.addAction(OKAction)

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.present(alertController, animated: true, completion: nil)
        }
    }

    func infoAlert(title: String? = "", message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func errorAlert(message: String?) {
        errorAlert(message: message, handler: nil)
    }

    func defaultErrorAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "Some error occured. Try again later.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func actionSheetAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }

    func newSocialAlert(name: String?, link: String?, completion: ((_ name: String?, _ url: String?) -> Void)?) {
        let ac = UIAlertController(title: "Нова соціальна мережа", message: "Будь ласка, введіть назву та посилання", preferredStyle: .alert)

        let isEditing = !(name ?? "").isEmpty || !(link ?? "").isEmpty

        let submitAction = UIAlertAction(title: isEditing ? "Змінити": "Створити", style: .default) { [unowned ac] _ in
            let name = ac.textFields![safe: 0]?.text
            let url = ac.textFields?[safe: 1]?.text
            completion?(name, url)
        }
        submitAction.isEnabled = false
        let cancelAction = UIAlertAction(title: "Відмінити", style: .cancel, handler: nil)

        ac.addAction(submitAction)
        ac.addAction(cancelAction)

        ac.addTextField { (nameTextField) in
            nameTextField.text = name
            nameTextField.placeholder = "Назва"
        }
        ac.addTextField { (urlTextField) in
            urlTextField.text = link
            urlTextField.keyboardType = .URL
            urlTextField.placeholder = "Посилання, https://link.com"
        }

        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: ac.textFields?[safe: 1], queue: OperationQueue.main, using: { _ in
            let nameTextFieldTextCount = ac.textFields?[safe: 0]?.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            let urlTextFieldextCount = ac.textFields?[safe: 1]?.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            submitAction.isEnabled = (nameTextFieldTextCount > 0) && (urlTextFieldextCount > 0)
        })

        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: ac.textFields?[safe: 0], queue: OperationQueue.main, using: { _ in
            let nameTextFieldTextCount = ac.textFields?[safe: 0]?.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            let urlTextFieldextCount = ac.textFields?[safe: 1]?.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            submitAction.isEnabled = (nameTextFieldTextCount > 0) && (urlTextFieldextCount > 0)
        })

        present(ac, animated: true, completion: nil)
    }

    func newFolderAlert(folderName: String?, completion: ((_ name: String) -> Void)?) {
        let isEditing = !(folderName ?? "").isEmpty
        let ac = UIAlertController(title: isEditing ? "Редагувати список" : "Новий список", message: "Задайте назву новому списку", preferredStyle: .alert)

        let submitAction = UIAlertAction(title: "Зберегти", style: .default) { [unowned ac] _ in
            let name = ac.textFields![safe: 0]?.text
            completion?(name!)
        }
        submitAction.isEnabled = false
        let cancelAction = UIAlertAction(title: "Скасувати", style: .cancel, handler: nil)

        ac.addAction(submitAction)
        ac.addAction(cancelAction)

        ac.addTextField { (nameTextField) in
            nameTextField.text = folderName ?? ""
            nameTextField.placeholder = "Назва"
        }

        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: ac.textFields?[safe: 0], queue: OperationQueue.main, using: { _ in
            let nameTextFieldTextCount = ac.textFields?[safe: 0]?.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            submitAction.isEnabled = (nameTextFieldTextCount > 0)
        })

        present(ac, animated: true, completion: nil)
    }


}

extension UIAlertAction {

    func setFont(color: UIColor) {
        setValue(color, forKey: "UIAlertActionConstants.alertActionTextColor")
    }
}
