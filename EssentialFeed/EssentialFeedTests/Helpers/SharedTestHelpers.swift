//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 07/12/21.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    return Data("invalid json".utf8)
}

func makeItemJSON(_ items:[[String:Any]]) -> Data {
    let json = ["items" : items]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
