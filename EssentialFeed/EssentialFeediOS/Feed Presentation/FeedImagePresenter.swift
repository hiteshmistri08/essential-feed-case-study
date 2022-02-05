//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Hitesh on 05/02/22.
//

import Foundation
import EssentialFeed

protocol FeedImageView {
    associatedtype Image
    
    func display(_ viewModel: FeedImageViewModel<Image>)
}


final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?

    internal init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
        
    private struct InvalidImageDataError: Error {}
    
    func didStartLoadingImageData(for model: FeedImage) {
        self.view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false))
    }
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        
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
    
    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        self.view.display(FeedImageViewModel(
            description: model.description,
            location: model.description,
            image: nil,
            isLoading: false,
            shouldRetry: true))
    }
}