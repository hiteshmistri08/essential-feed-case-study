//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 12/02/22.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    
    // MAK: - Helper
    
    class ViewSpy {
        let messages = [Any]()
    }
}
