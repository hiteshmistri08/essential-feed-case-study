//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Hitesh on 12/02/22.
//


struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
