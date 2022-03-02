//
//  RemoteLoader.swift
//  EssentialFeed
//
//  Created by Hitesh on 01/03/22.
//

import Foundation

public final class RemoteLoader<Resource> {
    private let url : URL
    private let client:HTTPClient
    private let mapper: Mapper
    
    public enum Error:Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<Resource, Swift.Error>
    public typealias Mapper = (Data, HTTPURLResponse) throws -> Resource

    public init(url:URL,client:HTTPClient, mapper: @escaping Mapper) {
        self.url = url
        self.client = client
        self.mapper = mapper
    }
    
    public func load(completion:@escaping(Result) -> Void) {
        ///Clients don't need to know about the specific URL. They just want to load a feed of items, so we hide the URL as an implementation detail.
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success((data, response)):
                completion(self.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private func map(_ data:Data, from response: HTTPURLResponse) -> Result {
        do {
            return .success(try mapper(data, response))
        } catch  {
            return .failure(Error.invalidData)
        }
    }
}
