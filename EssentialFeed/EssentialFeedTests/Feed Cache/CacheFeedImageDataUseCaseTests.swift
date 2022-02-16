//
//  CacheFeedImageDataUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 17/02/22.
//

import XCTest
import EssentialFeed

class CacheFeedImageDataUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageUponCreation() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.recievedMessages.isEmpty)
    }
    
    func test_saveImageDataForURL_requestsImageDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()
        
        sut.save(data, for: url) {_ in}
        
        XCTAssertEqual(store.recievedMessages, [.insertion(data: data, for: url)])
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line:UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file)
        return (sut, store)
    }
    
}
