//
//  AddDataManager.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation

class AddDataManager : NSObject {
    let dataStore : DataStore
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }
    
    func addNewEntry(_ entry: TodoItem) {
        dataStore.newTodoItem(entry)
        dataStore.save()
    }
}
