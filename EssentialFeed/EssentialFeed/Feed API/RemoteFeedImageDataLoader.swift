//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Hitesh on 14/02/22.
//

import Foundation

public final class RemoteFeedImageDataLoader {
    private let client : HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private final class HTTPClientTaskWrapper: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletion()
            wrapped?.cancel()
        }
        
        private func preventFurtherCompletion() {
            completion = nil
        }
    }
    
    @discardableResult
    public func loadImageDataFromURL(from url: URL, completion:@escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask  {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200, data.isEmpty == false {
                    task.complete(with: .success(data))
                } else {
                    task.complete(with: .failure(Error.invalidData))
                }
            case let .failure(error): task.complete(with: .failure(error))
            }
        }
        
        return task
    }
}
