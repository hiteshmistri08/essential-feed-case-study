//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Hitesh on 17/02/22.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion:@escaping(Result) -> Void)
}
