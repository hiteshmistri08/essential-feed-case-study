//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Hitesh on 04/07/21.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data,HTTPURLResponse),Error>
    
    /// The completion handler can be invoked in any
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func get(from url:URL, completion:@escaping(Result) -> Void) -> HTTPClientTask
}
