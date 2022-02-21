//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Hitesh on 20/02/22.
//

import Foundation
import EssentialFeed

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: nil, location: nil, url: URL(string: "http://any-url.com")!)]
}
