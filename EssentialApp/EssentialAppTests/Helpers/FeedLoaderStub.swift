//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Hitesh on 21/02/22.
//

import Foundation
import EssentialFeed

final class FeedLoaderStub {
    private let result: Swift.Result<[FeedImage], Error>
    
    init(result: Swift.Result<[FeedImage], Error>) {
        self.result = result
    }
    
    func load(completion: @escaping (Swift.Result<[FeedImage], Error>) -> Void) {
        completion(result)
    }
}
