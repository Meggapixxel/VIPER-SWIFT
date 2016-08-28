
//
//  ListDataManager.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/5/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation

class ListDataManager : NSObject {
    let dataStore : DataStore
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }

    func todoItemsBetweenStartDate(_ startDate: Date, endDate: Date, completion: (([TodoItem]) -> Void)!) {
        let calendar = Calendar.autoupdatingCurrent
        let beginning = calendar.dateForBeginningOfDay(startDate)
        let end = calendar.dateForEndOfDay(endDate)
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", argumentArray: [beginning, end])
        let sortDescriptors: [NSSortDescriptor] = []
        
        dataStore.fetchEntriesWithPredicate(predicate,
            sortDescriptors: sortDescriptors,
            completionBlock: completion)
    }
    
}
