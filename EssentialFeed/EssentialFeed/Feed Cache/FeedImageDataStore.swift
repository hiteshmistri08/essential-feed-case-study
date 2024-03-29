//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Hitesh on 17/02/22.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
