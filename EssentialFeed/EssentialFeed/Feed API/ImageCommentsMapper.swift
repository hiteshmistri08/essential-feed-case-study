//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Hitesh on 28/02/22.
//

import Foundation

final class ImageCommentsMapper {
    private struct Root:Decodable {
        let items : [RemoteFeedItem]
    }
        
    private init() { }
    
    internal static func map(_ data:Data, from response:HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }
        return root.items
    }
}
