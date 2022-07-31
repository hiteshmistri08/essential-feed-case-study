//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Hitesh on 25/11/21.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    /// The completion handler can be invoked in any
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedFeed() throws
    
    /// The completion handler can be invoked in any
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ feed:[LocalFeedImage], timestamp: Date) throws
    
    /// The completion handler can be invoked in any
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve() throws -> CachedFeed?
}
