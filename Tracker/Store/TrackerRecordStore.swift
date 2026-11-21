//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Алик on 18.11.2026.
//

import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateRecords()
}

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        
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
    
    convenience override init() {
        let context = DataBaseStore.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        _ = fetchedResultsController
    }
    
    func addRecord(_ record: TrackerRecord) throws {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.trackerId = record.trackerId
        recordCoreData.date = record.date
        try context.save()
    }
    
    func deleteRecord(_ record: TrackerRecord) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "trackerId == %@ AND date == %@",
            record.trackerId as CVarArg,
            record.date as CVarArg
        )
        
        if let result = try context.fetch(request).first {
            context.delete(result)
            try context.save()
        }
    }
    
    func fetchRecords() throws -> Set<TrackerRecord> {
        guard let objects = fetchedResultsController.fetchedObjects else {
            return []
        }
        
        let records: [TrackerRecord] = objects.compactMap { coreData in
            guard let id = coreData.trackerId, let date = coreData.date else { return nil }
            return TrackerRecord(trackerId: id, date: date)
        }
        return Set(records)
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateRecords()
    }
}
