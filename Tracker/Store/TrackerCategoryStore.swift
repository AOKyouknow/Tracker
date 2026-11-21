//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Алик on 18.11.2026.
//

import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingError
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func categoryStoreDidUpdate()
}

final class TrackerCategoryStore: NSObject {
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let trackerStore: TrackerStore
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()
    
    var categories: [TrackerCategory] {
        guard let objects = fetchedResultsController.fetchedObjects else { return [] }
        return objects.compactMap { try? makeCategory(from: $0) }
    }
    
    convenience override init() {
        let context = DataBaseStore.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.trackerStore = TrackerStore(context: context)
        super.init()
        _ = fetchedResultsController
    }
    
    func addNewCategory(title: String) throws {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = title
        try context.save()
    }
    
    func fetchCategoryCoreData(with title: String) throws -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        return try context.fetch(request).first
    }
    
    private func makeCategory(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = categoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingError
        }
        
        let trackersSet = categoryCoreData.trackers as? Set<TrackerCoreData> ?? []
        let trackers = trackersSet.compactMap { try? trackerStore.makeTracker(from: $0) }
        
        return TrackerCategory(title: title, trackers: trackers)
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.categoryStoreDidUpdate()
    }
}
