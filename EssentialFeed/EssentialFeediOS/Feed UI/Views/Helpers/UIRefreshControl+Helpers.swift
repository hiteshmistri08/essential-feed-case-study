//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Hitesh on 12/02/22.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
