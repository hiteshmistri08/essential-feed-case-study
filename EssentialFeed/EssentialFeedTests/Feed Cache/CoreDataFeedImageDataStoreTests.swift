//
//  CoreDataFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 18/02/22.
//

import XCTest
import EssentialFeed

class CoreDataFeedImageDataStoreTests: XCTestCase {
    
    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() {
        let sut = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let nonMatchingURL = URL(string: "http://another-url.com")!
        
        insert(anyData(), for: url, into: sut)
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() {
        let sut = makeSUT()
        let storeData = anyData()
        let matchingURL = URL(string: "http://a-url.com")!
        
        insert(storeData, for: matchingURL, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(storeData), for: matchingURL)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() {
        let sut = makeSUT()
        let firstStoreData = Data("first".utf8)
        let lastStoreData = Data("last".utf8)
        let url = URL(string: "http://a-url.com")!
        
        insert(firstStoreData, for: url, into: sut)
        insert(lastStoreData, for: url, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(lastStoreData), for: url)
    }
        
    //MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataFeedStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func notFound() -> Result<Data?, Error> {
        return .success(.none)
    }
    
    private func found(_ data:Data) -> Result<Data?, Error> {
        return .success(data)
    }
    
    private func localImage(url: URL) -> LocalFeedImage {
        return LocalFeedImage(id: UUID(), description: nil, location: nil, url: url)
    }
    
    private func expect(_ sut: CoreDataFeedStore, toCompleteRetrievalWith expectedResult: Result<Data?, Error>, for url: URL, file: StaticString = #file, line: UInt = #line) {
        let receivedResult = Result { try sut.retrieve(dataForURL: url) }
        
        switch (receivedResult, expectedResult) {
        case (let .success(receivedData), let .success(expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            
        default:
            XCTFail("Expected \(receivedResult), got \(expectedResult) instead", file: file, line: line)
        }
    }
    
    private func insert(_ data: Data, for url: URL, into sut: CoreDataFeedStore, file: StaticString = #file, line: UInt = #line) {
        do {
            let image = localImage(url: url)
            try sut.insert([image], timestamp: Date())
            try sut.insert(data, for: url)
        } catch {
            XCTFail("Failed to insert \(data) with error \(error)", file: file, line: line)
        }
    }
}
