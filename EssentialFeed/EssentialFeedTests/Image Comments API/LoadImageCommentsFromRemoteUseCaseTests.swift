//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 28/02/22.
//

import XCTest
import EssentialFeed

class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {
    
    func test_load_deliversErrorOnNon2xxHTTPResponse() {
        let (sut, client) = makeSUT()
        
        let sample = [199, 150, 300, 400, 500]
        
        sample.enumerated().forEach { (index,code) in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn2xxHTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        let sample = [200, 201, 250, 280, 299]

        sample.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let invalidJSON = Data("invalid json".utf8)
                client.complete(withStatusCode: 200, data:invalidJSON, at: index)
            })
        }
    }
    
    func test_load_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        let sample = [200, 201, 250, 280, 299]

        sample.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWith: .success([]), when: {
                let emptyJOSN = makeItemJSON([])
                client.complete(withStatusCode: 200, data: emptyJOSN, at: index)
            })
        }
    }
    
    func test_load_deliversItemsOn2xxHTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(
            id: UUID(),
            message: "a message",
            createdAt: (date: Date(timeIntervalSince1970: 1598627222), iso8601String: "2020-08-28T15:07:02+00:00"),
            username: "a username"
            )
        
        let item2 = makeItem(
            id: UUID(),
            message: "another message",
            createdAt: (date: Date(timeIntervalSince1970: 1577881882), iso8601String: "2020-01-01T12:31:22+00:00"),
            username: "another username"
            )
        
        let items = [item1.model,item2.model]
        
        let sample = [200, 201, 250, 280, 299]

        sample.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWith: .success(items), when: {
                let json = makeItemJSON([item1.json, item2.json])
                client.complete(withStatusCode: 200, data: json, at: index)
            })
        }
    }
    
    // MARK: - Helpers

    private func makeSUT(url:URL = URL(string: "http://a-url.com")!, file:StaticString = #file, line:UInt = #line) -> (RemoteImageCommentsLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteImageCommentsLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error:RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
        return .failure(error)
    }
    
    private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), username: String) -> (model: ImageComment,json:[String:Any]) {
        let model = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)        
        let itemJSON: [String:Any] = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.iso8601String,
            "author": [
                "username": username
            ]
        ]
        return (model, itemJSON)
    }
    
    private func makeItemJSON(_ items:[[String:Any]]) -> Data {
        let json = ["items" : items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut:RemoteImageCommentsLoader, toCompleteWith expectedResult:RemoteImageCommentsLoader.Result, when action:() -> Void, file:StaticString = #filePath, line:UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load{ receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(recievedItems),.success(expectedItems)):
                XCTAssertEqual(recievedItems, expectedItems, file:file, line:line)
                
            case let (.failure(receivedError as RemoteImageCommentsLoader.Error), .failure(expectedError as RemoteImageCommentsLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file:file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}
