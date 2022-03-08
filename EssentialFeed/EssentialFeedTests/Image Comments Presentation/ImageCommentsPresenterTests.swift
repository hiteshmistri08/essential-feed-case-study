//
//  ImageCommentsPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 07/03/22.
//

import XCTest
import EssentialFeed

class ImageCommentsPresenterTests: XCTestCase {
    
    func test_title_isLocalized()  {
        XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
    }
    
    func test_map_createsViewModels() {
        let now = Date()
        let calender = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        
        let comments = [
            ImageComment(
                id: UUID(),
                message: "a message",
                createdAt: now.adding(minutes: -5, calender: calender),
                username: "a username"),
            ImageComment(
                id: UUID(),
                message: "another message",
                createdAt: now.adding(days: -1, calender: calender),
                username: "another username")
        ]
        
        let viewModel = ImageCommentsPresenter.map(
            comments,
            currentDate: now,
            calendar: calender,
            locale: locale
        )
        
        XCTAssertEqual(viewModel.comments, [
            ImageCommentViewModel(
                message: "a message",
                date: "5 minutes ago",
                username: "a username"
            ),
            ImageCommentViewModel(
                message: "another message",
                date: "1 day ago",
                username: "another username"
            )
        ])
    }
    
    // MAK: - Helper
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        
        return value
    }
    
}
