//
//  CoreDataFeedStore+FeedStore.swift
//  EssentialFeed
//
//  Created by Hitesh on 19/02/22.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map{ cache in
                    CachedFeed(feed: cache.localFeed, timestamp: cache.timestamp)
                }
            })
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], _ currentDate: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = currentDate
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                try context.save()
            })
        }
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
}
