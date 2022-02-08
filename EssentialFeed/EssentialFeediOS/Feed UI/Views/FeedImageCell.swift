//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Hitesh on 29/01/22.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    @IBOutlet public var locationContainer: UIView!
    @IBOutlet public var locationLabel: UILabel!
    @IBOutlet public var feedImageContainer: UIView!
    @IBOutlet public var feedImageView: UIImageView!
    @IBOutlet public var feedImageRetryButton: UIButton!
    @IBOutlet public var descriptionLabel: UILabel!
 
    var onRetry: (() -> Void)?
    
    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
}
