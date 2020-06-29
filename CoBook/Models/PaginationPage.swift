//
//  PaginationPage.swift
//  CoBook
//
//  Created by protas on 5/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct PaginationPage<T> {

    public let pageSize: UInt
    public var offset: UInt {
        get {
            return UInt(items.count)
        }
    }

    public var items: [T]
    public var isNeedToLoadNextPage = false
    public var isFetching = false

    init(pageSize: UInt, items: [T] = []) {
        self.pageSize = pageSize
        self.items = items
        self.isNeedToLoadNextPage = (items.count == pageSize)
    }
    
    mutating func append(items: [T]) {
        self.items.append(contentsOf: items)
        self.isNeedToLoadNextPage = (items.count == pageSize)
    }
    
    
}
