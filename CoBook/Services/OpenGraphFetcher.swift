//
//  OpenGraphFetcher.swift
//  CoBook
//
//  Created by protas on 3/31/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import SwiftSoup

struct OpenGraphFetcher {

    func fetchOpenGraphImage(from url: URL, completion: @escaping (Result<String?>) -> Void) -> DispatchWorkItem? {

        var imageStrPath: String?

        let workItem = DispatchWorkItem {
            do {
                let html = try String.init(contentsOf: url)
                let document = try SwiftSoup.parse(html)
                let elements = try document.select("meta[property=\"og:image\"]")
                imageStrPath = elements.first()?.getAttributes()?.get(key: "content")
            } catch let error {
                imageStrPath = nil
                Log.error(error.localizedDescription)
            }
        }

        DispatchQueue.global(qos: .utility).async(execute: workItem)
        workItem.notify(queue: .main) {
            if workItem.isCancelled {
                return
            }
            completion(.success(imageStrPath))
        }

        return workItem
    }
}
