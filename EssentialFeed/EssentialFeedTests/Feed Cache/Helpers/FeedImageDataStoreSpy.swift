//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 17/02/22.
//

import Foundation
import EssentialFeed

class FeedImageDataStoreSpy: FeedImageDataStore {
    enum Message: Equatable {
        case insertion(data: Data, for: URL)
        case retrieve(dataForURL: URL)
    }
    
    private var completions = [(FeedImageDataStore.RetrievalResult) -> Void]()
    private(set) var recievedMessages = [Message]()
    
    
    func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
        recievedMessages.append(.insertion(data: data, for: url))
    }
    
    func retrieve(dataForURL url: URL, completion:@escaping(FeedImageDataStore.RetrievalResult) -> Void) {
        recievedMessages.append(.retrieve(dataForURL: url))
        completions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        completions[index](.success(data))
    }
}
