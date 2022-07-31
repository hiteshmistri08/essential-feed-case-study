//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Hitesh on 21/02/22.
//

import Foundation

public protocol FeedCache {    
    func save(_ feed: [FeedImage]) throws
}
