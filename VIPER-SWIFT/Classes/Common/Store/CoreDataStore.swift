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
    func fetchEntriesWithPredicate(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor], completionBlock: (([TodoItem]) -> Void)!)
    func newTodoItem(entiry: TodoItem)
    func save()
}

class CoreDataStore : NSObject, DataStore {
    var persistentStoreCoordinator : NSPersistentStoreCoordinator!
    var managedObjectModel : NSManagedObjectModel!
    var managedObjectContext : NSManagedObjectContext!
    
    override init() {
        managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let domains = NSSearchPathDomainMask.UserDomainMask
        let directory = NSSearchPathDirectory.DocumentDirectory

        let applicationDocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(directory, inDomains: domains).first!
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        
        let storeURL = applicationDocumentsDirectory.URLByAppendingPathComponent("VIPER-SWIFT.sqlite")
        
        try! persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: "", URL: storeURL, options: options)

        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext.undoManager = nil
        
        super.init()
    }
    
    func fetchEntriesWithPredicate(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor], completionBlock: (([TodoItem]) -> Void)!) {
        let fetchRequest = NSFetchRequest(entityName: "TodoItem")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        managedObjectContext.performBlock {
            let queryResults = try? self.managedObjectContext.executeFetchRequest(fetchRequest)
            let managedResults = queryResults! as! [ManagedTodoItem]
            completionBlock(managedResults.map(self.todoItemFromDataStoreEntry))
        }
    }
    
    func newTodoItem(entry: TodoItem) {
        let newEntry = NSEntityDescription.insertNewObjectForEntityForName("TodoItem", inManagedObjectContext: managedObjectContext) as! ManagedTodoItem
        newEntry.name = entry.name
        newEntry.date = entry.dueDate
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch _ {
        }
    }
    
    func todoItemFromDataStoreEntry(entry: ManagedTodoItem) -> TodoItem {
        return TodoItem(dueDate: entry.date, name: entry.name as String)
    }
    
}
