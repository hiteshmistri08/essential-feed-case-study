//
//  FeedLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Hitesh on 20/02/22.
//

import Foundation
import EssentialFeed

public final class FeedLoaderWithFallbackComposite: FeedLoader {
    private let primaryLoader: FeedLoader
    private let fallbackLoader: FeedLoader
    
    public init(primary: FeedLoader, fallback: FeedLoader) {
        self.primaryLoader = primary
        self.fallbackLoader = fallback
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        primaryLoader.load { [weak self] result in
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                self?.fallbackLoader.load(completion: completion)
            }
        }
    }
}
