//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Hitesh on 05/02/22.
//

import Foundation

public protocol FeedImageView {
    associatedtype Image
    
    func display(_ viewModel: FeedImageViewModel<Image>)
}

public final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?

    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
        
    private struct InvalidImageDataError: Error {}
    
    public func didStartLoadingImageData(for model: FeedImage) {
        self.view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false))
    }
    
    public func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }
        
        self.view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: image,
            isLoading: false,
            shouldRetry: false))
    }
    
    public func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        self.view.display(FeedImageViewModel(
            description: model.description,
            location: model.description,
            image: nil,
            isLoading: false,
            shouldRetry: true))
    }
}