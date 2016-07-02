//
//  AddPresenter.swift
//  VIPER TODO
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import Dip

class AddPresenter : NSObject, AddModuleInterface {
    
    private let _addInteractor = Injected<AddInteractor>()
    var addInteractor : AddInteractor? { return _addInteractor.value }
    
    private let _addWireframe = Injected<AddWireframe>()
    var addWireframe : AddWireframe? { return _addWireframe.value }
    
    var addModuleDelegate : AddModuleDelegate?
    
    func cancelAddAction() {
        addWireframe?.dismissAddInterface()
        addModuleDelegate?.addModuleDidCancelAddAction()
    }
    
    func saveAddActionWithName(name: String, dueDate: NSDate) {
        addInteractor?.saveNewEntryWithName(name, dueDate: dueDate);
        addWireframe?.dismissAddInterface()
        addModuleDelegate?.addModuleDidSaveAddAction()
    }
    
    func configureUserInterfaceForPresentation(addViewUserInterface: AddViewInterface) {
        addViewUserInterface.setMinimumDueDate(NSDate())
    }
}