//
//  FeedCacheTestHeplers.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 07/12/21.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models:[FeedImage], local:[LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map{ LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    return (models, local)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
}

extension Date {
    func adding(seconds:TimeInterval) -> Date {
        return self + seconds
    }
    
    func adding(minutes: Int, calender: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calender.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int, calender: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calender.date(byAdding: .day, value: days, to: self)!
    }
}
