//
//  WeakRefVirtualProxy.swift
//  EssentialFeediOS
//
//  Created by Hitesh on 10/02/22.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object : T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy : ResourceLoadingView where T : ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        self.object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy : FeedImageView where T : FeedImageView, T.Image == UIImage {
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        self.object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy : ResourceErrorView where T : ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel) {
        self.object?.display(viewModel)
    }
}
