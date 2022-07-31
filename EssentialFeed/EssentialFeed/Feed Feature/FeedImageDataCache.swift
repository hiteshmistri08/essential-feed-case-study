//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Hitesh on 22/02/22.
//

import Foundation

public protocol FeedImageDataCache {
     func save(_ data: Data, for url: URL) throws
 }
