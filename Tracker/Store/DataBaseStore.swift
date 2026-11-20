//
//  DataBaseStore.swift
//  Tracker
//
//  Created by Алик on 20.11.2026.
//

import Foundation
import CoreData

final class DataBaseStore {
    static let shared: DataBaseStore  = DataBaseStore()
    
    private init() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModels")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(String(describing: error)), \(String(describing: error.localizedDescription))")
            }
        })
        
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
