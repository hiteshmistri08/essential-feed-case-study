//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Hitesh on 05/02/22.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location)
    }
}
