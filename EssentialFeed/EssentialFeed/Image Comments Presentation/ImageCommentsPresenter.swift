//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Hitesh on 07/03/22.
//

import Foundation

public final class ImageCommentsPresenter {
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
            tableName: "ImageComments",
            bundle: Bundle(for: Self.self),
            comment: "Title for the image comments view")
    }
}
