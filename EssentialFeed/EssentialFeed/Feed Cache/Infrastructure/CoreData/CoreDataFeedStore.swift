//
//  CoreDataFeedStore.swift
//  EssentialFeedTests
//
//  Created by Hitesh on 23/12/21.
//

import CoreData

public final class CoreDataFeedStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL) throws {
        let bundel = Bundle(for: CoreDataFeedStore.self)
        container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundel)
        context = container.newBackgroundContext()
    }
    
    // - MARK: Helper
    func perform(_ action:@escaping(NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
