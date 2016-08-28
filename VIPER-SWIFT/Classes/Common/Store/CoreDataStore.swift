//
//  CoreDataStore.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import CoreData

protocol DataStore {
    func fetchEntriesWithPredicate(_ predicate: NSPredicate, sortDescriptors: [NSSortDescriptor], completionBlock: (([TodoItem]) -> Void)!)
    func newTodoItem(_ entiry: TodoItem)
    func save()
}

class CoreDataStore : NSObject, DataStore {
    var persistentStoreCoordinator : NSPersistentStoreCoordinator!
    var managedObjectModel : NSManagedObjectModel!
    var managedObjectContext : NSManagedObjectContext!
    
    override init() {
        print("creating \(type(of: self))")
        managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let domains = FileManager.SearchPathDomainMask.userDomainMask
        let directory = FileManager.SearchPathDirectory.documentDirectory

        let applicationDocumentsDirectory = FileManager.default.urls(for: directory, in: domains).first!
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        
        let storeURL = applicationDocumentsDirectory.appendingPathComponent("VIPER-SWIFT.sqlite")
        
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: "", at: storeURL, options: options)

        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext.undoManager = nil
        
        super.init()
    }
    deinit {
        print("deinit \(type(of: self))")
    }

    
    func fetchEntriesWithPredicate(_ predicate: NSPredicate, sortDescriptors: [NSSortDescriptor], completionBlock: (([TodoItem]) -> Void)!) {
        let fetchRequest = NSFetchRequest<ManagedTodoItem>(entityName: "TodoItem")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        managedObjectContext.perform {
            let queryResults = try? self.managedObjectContext.fetch(fetchRequest)
            let managedResults = queryResults!
            completionBlock(managedResults.map(self.todoItemFromDataStoreEntry))
        }
    }
    
    func newTodoItem(_ entry: TodoItem) {
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: "TodoItem", into: managedObjectContext) as! ManagedTodoItem
        newEntry.name = entry.name
        newEntry.date = entry.dueDate
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch _ {
        }
    }
    
    func todoItemFromDataStoreEntry(_ entry: ManagedTodoItem) -> TodoItem {
        return TodoItem(dueDate: entry.date, name: entry.name as String)
    }
    
}
