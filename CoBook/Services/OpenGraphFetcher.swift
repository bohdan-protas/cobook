//
//  OpenGraphFetcher.swift
//  CoBook
//
//  Created by protas on 3/31/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import SwiftSoup

class OpenGraphFetcher {

    class func fetchOpenGraphImage(from url: URL, completion: @escaping (Result<String?, Error>) -> Void) -> DispatchWorkItem? {
        var document: Document?

        let queue = DispatchQueue.global(qos: .utility)
        let workItem = DispatchWorkItem (qos: .userInteractive) {
            do {
                let html = try String.init(contentsOf: url)
                document = try SwiftSoup.parse(html)
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        queue.async(execute: workItem)
        workItem.notify(queue: .main) {
            if workItem.isCancelled {
                return
            }
            do {
                let elements = try document?.select("meta[property=\"og:image\"]")
                let imageStrPath = elements?.first()?.getAttributes()?.get(key: "content")
                completion(.success(imageStrPath))
            } catch let error {
                completion(.failure(error))
            }
        }

        return workItem
    }
}
