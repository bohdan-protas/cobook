//
//  AddFeedbackPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 18.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol AddFeedbackView: class, AlertDisplayableView, LoadDisplayableView, NavigableView {
    func setButton(actived: Bool)
}

class AddFeedbackPresenter {

    weak var view: AddFeedbackView?
    
    private var cardID: Int?
    @Trimmed private var message: String = "" {
        didSet {
            view?.setButton(actived: !message.isEmpty)
        }
    }
    
    init(cardID: Int?) {
        self.cardID = cardID
    }
    
    func set(message: String?) {
        self.message = message ?? ""
        Log.debug(self.message)
    }
    
    func createFeedback() {
        view?.startLoading()
        APIClient.default.createFeedback(cardID: cardID, message: self.message) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view?.stopLoading(success: true, completion: {
                    self.view?.popController()
                })
            case .failure(let error):
                self.view?.stopLoading(success: false, completion: {
                    self.view?.errorAlert(message: error.localizedDescription)
                })
            }
        }
    }
    
    
}
