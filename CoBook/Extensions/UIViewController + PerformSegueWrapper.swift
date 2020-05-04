//
//  UIViewController + PerformSegueWrapper.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import ObjectiveC

// MARK: -

private let tokenRepository = PRSInMemotyTokenRepository()

extension DispatchQueue {
    @discardableResult
    static func prs_once(token: String, tokenRepository: PRSTokenRepository = tokenRepository, function: () -> ()) -> Bool {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        guard tokenRepository.contains(token) == false else {
            return false
        }
        tokenRepository.append(token)
        function()
        return true
    }
}

// MARK: -

struct PRSBox {
    let value: Any?
    init(_ x: Any?) {
        value = x
    }
}

// MARK: -

public typealias UIViewController_PRSConfigurate = (UIStoryboardSegue) -> ()

protocol PRSSegueRepository {
    func configurate(for identifier: String) -> UIViewController_PRSConfigurate?
    func saveConfigurate(_ configurate: @escaping UIViewController_PRSConfigurate, for identifier: String)
    func removeConfigurate(for identifier: String)
}

final class PRSInMemotySegueRepository: PRSSegueRepository {
    func configurate(for identifier: String) -> UIViewController_PRSConfigurate? {
        return dictionary[identifier]
    }

    func saveConfigurate(_ configurate: @escaping UIViewController_PRSConfigurate, for identifier: String) {
        dictionary[identifier] = configurate
    }

    func removeConfigurate(for identifier: String) {
        dictionary.removeValue(forKey: identifier)
    }

    private var dictionary: [String : UIViewController_PRSConfigurate] = [:]
}

// MARK: -

protocol PRSTokenRepository {
    func contains(_ token: String) -> Bool
    func append(_ token: String)
}

final class PRSInMemotyTokenRepository: PRSTokenRepository {
    func contains(_ token: String) -> Bool {
        return tokens.contains(token)
    }

    func append(_ token: String) {
        tokens.append(token)
    }

    private var tokens: [String] = []
}

// MARK: -

extension UIViewController {

    private enum Key {
        static let token: String = #file + "#(Key.token)"
        static var segueRepository = #file + "#(segueRepository)"
    }

    public func performSegue<T>(to clazz: T.Type, sender: Any? = nil, configurate: ((T?) -> ())? = nil)
        where T: UIViewController {
            let identifier = String(describing: clazz)
            performSegue(withIdentifier: identifier, sender: sender, configurate: { segue in
                let viewController = segue.destination as? T
                configurate?(viewController)
            })
    }

    @objc public func performSegue(withIdentifier identifier: String,
                                 configurate: @escaping UIViewController_PRSConfigurate) {
        performSegue(withIdentifier: identifier, sender: nil, configurate: configurate)
    }

    @objc public func performSegue(withIdentifier identifier: String,
                                 sender: Any?,
                                 configurate: @escaping UIViewController_PRSConfigurate) {
        swizzlingPrepareForSegue()
        segueRepository.saveConfigurate(configurate, for: identifier)
        performSegue(withIdentifier: identifier, sender: sender)
    }

    private func swizzlingPrepareForSegue() {
        DispatchQueue.prs_once(token: Key.token, function: {
            let originalSelector = #selector(UIViewController.prepare(for:sender:))
            let swizzledSelector = #selector(UIViewController.prepare(for:sender:))

            let clazz = UIViewController.self
            let originalMethod = class_getInstanceMethod(clazz, originalSelector)
            let swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector)

            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        })
    }

    @objc private func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            prepare(for: segue, sender: sender)
            return
        }

        segueRepository.configurate(for: identifier)?(segue)
        prepare(for: segue, sender: sender)
        segueRepository.removeConfigurate(for: identifier)
    }

    private var segueRepository: PRSSegueRepository {
        get {
            let box = objc_getAssociatedObject(self, &Key.segueRepository) as? PRSBox
            guard let repository = box?.value as? PRSSegueRepository else {
                let repository = PRSInMemotySegueRepository()
                self.segueRepository = repository
                return repository
            }
            return repository
        }
        set {
            objc_setAssociatedObject(self, &Key.segueRepository, PRSBox(newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
