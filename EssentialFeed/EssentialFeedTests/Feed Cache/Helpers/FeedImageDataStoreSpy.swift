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
    
    private(set) var recievedMessages = [Message]()
    private var retrievalResult: Result<Data?, Error>?
    private var insertionResult: Result<Void, Error>?
    
    func insert(_ data: Data, for url: URL) throws {
        recievedMessages.append(.insertion(data: data, for: url))
        try insertionResult?.get()
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        recievedMessages.append(.retrieve(dataForURL: url))
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalResult = .success(data)
    }
}
