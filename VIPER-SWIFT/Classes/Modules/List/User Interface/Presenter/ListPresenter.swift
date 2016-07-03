//
//  ListPresenter.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/5/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit

class ListPresenter : NSObject {
    var listInteractor : ListInteractorInput?
    weak var listWireframe : ListWireframe?
    weak var userInterface: ListViewInterface?
}

extension ListPresenter: ListInteractorOutput {

    func foundUpcomingItems(upcomingItems: [UpcomingItem]) {
        if upcomingItems.count == 0 {
            userInterface?.showNoContentMessage()
        } else {
            updateUserInterfaceWithUpcomingItems(upcomingItems)
        }
    }
    
    func updateUserInterfaceWithUpcomingItems(upcomingItems: [UpcomingItem]) {
        let upcomingDisplayData = upcomingDisplayDataWithItems(upcomingItems)
        userInterface?.showUpcomingDisplayData(upcomingDisplayData)
    }
    
    func upcomingDisplayDataWithItems(upcomingItems: [UpcomingItem]) -> UpcomingDisplayData {
        let collection = UpcomingDisplayDataCollection()
        collection.addUpcomingItems(upcomingItems)
        return collection.collectedDisplayData()
    }
    

}

extension ListPresenter: ListModuleInterface {

    func updateView() {
        listInteractor?.findUpcomingItems()
    }

    func addNewEntry() {
        listWireframe?.presentAddInterface()
    }
    
}

extension ListPresenter: AddModuleDelegate {

    func addModuleDidCancelAddAction() {
        // No action necessary
    }
    
    func addModuleDidSaveAddAction() {
        updateView()
    }
    
}
