//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Hitesh on 02/02/22.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
