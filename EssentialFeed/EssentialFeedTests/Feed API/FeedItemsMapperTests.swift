//
//  FeedItemsMapperTests.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 02/05/21.
//

import XCTest
import EssentialFeed

class FeedItemsMapperTests : XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemJSON([])
        let sample = [199, 201, 300, 400, 500]
        
        try sample.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyJOSN = makeItemJSON([])
        
        let result = try FeedItemsMapper.map(emptyJOSN, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithInvalidJSON() throws {
        let item1 = makeItem(
            id: UUID(),
            description: nil,
            location: nil,
            imageURL: URL(string: "http://a-url.com")!)
        
        let item2 = makeItem(id: UUID(), description: "a description", location: "a location", imageURL: URL(string: "http://another-url.com")!)
        
        let json = makeItemJSON([item1.json, item2.json])
        
        let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model,item2.model])
    }
    
    // MARK: - Helpers
    
    private func failure(_ error:RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
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
}

private extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
