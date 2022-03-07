//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Hitesh on 05/02/22.
//


public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
