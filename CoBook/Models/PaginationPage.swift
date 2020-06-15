//
//  PaginationPage.swift
//  CoBook
//
//  Created by protas on 5/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct PaginationPage<T> {

    var pageSize: UInt
    var offset: UInt {
        get {
            return UInt(items.count)
        }
    }

    var items: [T] {
        willSet {
            isNeedToLoadNextPage = (newValue.count == pageSize)
        }
    }

    var isNeedToLoadNextPage = false
    var isFetching = false

    init(pageSize: UInt, items: [T] = []) {
        self.pageSize = pageSize
        self.items = items
        self.isNeedToLoadNextPage = (items.count == pageSize)
    }
}
