//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 14/02/22.
//

import XCTest
import EssentialFeed

final class LocalFeedImageDataLoader {
    init(store: Any) {
        
    }
}

class LocalFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotMessageUponCreation() {
        let (_, client) = makeSUT()
        
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line:UInt = #line) -> (sut: LocalFeedImageDataLoader, client: FeedStoreSpy) {
        let client = FeedStoreSpy()
        let sut = LocalFeedImageDataLoader(store: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file)
        return (sut, client)
    }
    
    private class FeedStoreSpy {
        let requestedURLs = [Any]()
        
    }
}
