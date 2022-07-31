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
    
    func test_saveImageDataForURL_requestsImageDataInsertionForURL() throws {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()
        
        try? sut.save(data, for: url)
        
        XCTAssertEqual(store.recievedMessages, [.insertion(data: data, for: url)])
    }
    
    func test_saveImageDataFromURL_failsOnStoreInsertionError() {
        let (sut, store) = makeSUT()
        
        expect(with: sut, toCompleteWith: failed(), when: {
            let insertionError = anyNSError()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_saveImageDataFromURL_succeedsOnSuccessfulStoreInsertion() {
        let (sut, store) = makeSUT()
        
        expect(with: sut, toCompleteWith: .success(()), when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line:UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file)
        return (sut, store)
    }
    
    private func failed() -> Result<Void, Error> {
        return .failure(LocalFeedImageDataLoader.SaveError.failed)
    }
    
    private func expect(with sut: LocalFeedImageDataLoader, toCompleteWith expectedResult: Result<Void, Error>, when action:() -> Void, file: StaticString = #file, line: UInt = #line) {
        action()
        
        let receivedResult = Result { try sut.save(anyData(), for: anyURL()) }
        switch (receivedResult, expectedResult) {
        case (.success, .success):
            break
            
        case (let .failure(receivedError as LocalFeedImageDataLoader.SaveError), let .failure(expectedError as LocalFeedImageDataLoader.SaveError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
