//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 13/02/22.
//

import XCTest
import EssentialFeed

final class RemoteFeedImageDataLoader {
    let client : HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageDataFromURL(from url: URL, completion:@escaping (FeedImageDataLoader.Result) -> Void)  {
        client.get(from: url) { result in
            switch result {
            case let .failure(error): completion(.failure(error))
            default: break
            }
        }
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT()
        
        sut.loadImageDataFromURL(from: url, completion: { _ in })
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadImageDataFromURLTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT()
        
        sut.loadImageDataFromURL(from: url, completion: { _ in })
        sut.loadImageDataFromURL(from: url, completion: { _ in })

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_loadImageDataFromURL_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let expectedError = NSError(domain: "a client error", code: 0)
    
        expect(sut, toCompleteWith: .failure(expectedError), when: {
            client.complete(with: expectedError)
        })
    }
    
    // MARK: - Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedImageDataLoader, toCompleteWith expectedReult: FeedImageDataLoader.Result, when action:() -> Void) {
        let url = URL(string: "https://a-given-url.com")!
     
        let exp = expectation(description: "Wait for load completion")
        sut.loadImageDataFromURL(from: url) { result in
            switch (result, expectedReult) {
            case let (.failure(resultedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(resultedError, expectedError)
            default:
                XCTFail("Expected result should be error")
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        var requestedURLs : [URL] {
            return messages.map { $0.url}
        }

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url,completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
    }
}
