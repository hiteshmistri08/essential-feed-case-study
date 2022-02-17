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
    
    private var retrievalCompletions = [(FeedImageDataStore.RetrievalResult) -> Void]()
    private var insertionCompletions = [(FeedImageDataStore.InsertionResult) -> Void]()
    private(set) var recievedMessages = [Message]()
    
    
    func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
        recievedMessages.append(.insertion(data: data, for: url))
        insertionCompletions.append(completion)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func retrieve(dataForURL url: URL, completion:@escaping(FeedImageDataStore.RetrievalResult) -> Void) {
        recievedMessages.append(.retrieve(dataForURL: url))
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
}
