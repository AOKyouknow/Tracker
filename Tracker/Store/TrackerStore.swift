//
//  TrackerStore.swift
//  Tracker
//
//  Created by Алик on 18.11.2026.
//

import CoreData
import UIKit

enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidDate
}

protocol TrackerStoreDelegate: AnyObject {
    func trackerStoreDidUpdate()
}

final class TrackerStore: NSObject {
    weak var delegate: TrackerStoreDelegate?
    
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        controller.delegate = self
        
        try? controller.performFetch()
        return controller
    }()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        _ = fetchedResultsController
    }
    
    convenience override init() {
        let context = DataBaseStore.shared.context
        self.init(context: context)
    }
    
    var trackers: [Tracker] {
        guard let objects = fetchedResultsController.fetchedObjects else {
            return []
        }
        return objects.compactMap {
            try? makeTracker(from: $0)
        }
    }
    
    func addNewTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.colorHex = UIColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.schedule = tracker.schedule.map { $0.rawValue } as NSObject
        trackerCoreData.category = category
        
        try context.save()
    }
    
    func makeTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard
            let id = trackerCoreData.id,
            let title = trackerCoreData.title,
            let emoji = trackerCoreData.emoji,
            let colorHex = trackerCoreData.colorHex,
            let scheduleRaw = trackerCoreData.schedule as? [String]
        else {
            throw TrackerStoreError.decodingErrorInvalidDate
        }
        let schedule = Set(scheduleRaw.compactMap { WeekDay(rawValue: $0) })
        let color = UIColorMarshalling.color(from: colorHex)
        return Tracker(id: id, title: title, color: color, emoji: emoji, schedule: schedule)
        
    }
    
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.trackerStoreDidUpdate()
    }
}
