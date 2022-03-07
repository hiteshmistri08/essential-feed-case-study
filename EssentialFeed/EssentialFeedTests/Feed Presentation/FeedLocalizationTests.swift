//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Hitesh on 10/02/22.
//

import XCTest
@testable import EssentialFeed

class FeedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
    
}
