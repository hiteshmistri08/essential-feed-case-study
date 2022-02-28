//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 28/02/22.
//

import XCTest
import EssentialFeed

class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {
    
    func test_init() {
        let (_ ,client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut,client) = makeSUT(url:url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut,client) = makeSUT(url:url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url,url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let sample = [199, 201, 300, 400, 500]
        
        sample.enumerated().forEach { (index,code) in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data:invalidJSON)
        })
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            let emptyJOSN = makeItemJSON([])
            client.complete(withStatusCode: 200, data: emptyJOSN)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(
            id: UUID(),
            description: nil,
            location: nil,
            imageURL: URL(string: "http://a-url.com")!)
        
        let item2 = makeItem(id: UUID(), description: "a description", location: "a location", imageURL: URL(string: "http://another-url.com")!)
        
        let items = [item1.model,item2.model]
        
        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
        
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut:RemoteImageCommentsLoader? = RemoteImageCommentsLoader(url: url, client: client)
        
        var captureResults = [RemoteImageCommentsLoader.Result]()
        sut?.load{ captureResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemJSON([]))
        
        XCTAssertTrue(captureResults.isEmpty)
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
    
    private func makeItem(id:UUID, description:String? = nil, location:String? = nil, imageURL:URL) -> (model:FeedImage,json:[String:Any]) {
        let model = FeedImage(id: id, description: description, location: location, url: imageURL)
        
        let itemJSON = [
            "id":model.id.uuidString,
            "description":model.description,
            "location":model.location,
            "image":model.url.absoluteString
        ].compactMapValues{ $0 }
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
