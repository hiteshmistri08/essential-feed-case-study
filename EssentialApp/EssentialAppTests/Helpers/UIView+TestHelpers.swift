//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Hitesh on 26/02/22.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.main.run(until: Date())
    }
}
