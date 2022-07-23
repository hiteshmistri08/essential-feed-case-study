//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Hitesh on 17/02/22.
//

import Foundation

public final class LocalFeedImageDataLoader {
    private let store: FeedImageDataStore
    
    public enum SaveError: Error {
        case failed
    }
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

extension LocalFeedImageDataLoader: FeedImageDataCache {
    public typealias SaveResult = FeedImageDataCache.Result
    
    public func save(_ data: Data, for url: URL, completion: @escaping(FeedImageDataStore.InsertionResult) -> Void) {
        completion(SaveResult {
            try store.insert(data, for: url)
        }.mapError { _ in SaveError.failed })
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    public typealias LoadResult = FeedImageDataLoader.Result

    public enum LoadError: Error {
        case failed
        case notFound
    }
    
    private final class LoadImageDataTask: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        init(_ completion: @escaping(FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFutureCompletions()
        }
        
        private func preventFutureCompletions() {
            completion = nil
        }
    }
        
    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> FeedImageDataLoaderTask {
        let task = LoadImageDataTask(completion)
        
        task.complete(
            with: Swift.Result {
                try store.retrieve(dataForURL: url)
            }
            .mapError{ _ in LoadError.failed }
            .flatMap { data in
                data.map { .success($0) } ?? .failure(LoadError.notFound)
            })
        
        return task
    }
}
