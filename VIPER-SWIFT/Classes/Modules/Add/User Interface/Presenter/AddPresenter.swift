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
    
    //This is an example of auto-injected property
    private let _addInteractor = Injected<AddInteractor>()
    var addInteractor : AddInteractor? { return _addInteractor.value }
    
    //This auto-injected property will hold a week reference to underlying dependency avoiding retain cycle
    private let _addWireframe = InjectedWeak<AddWireframe>()
    var addWireframe : AddWireframe? { return _addWireframe.value }
    
    //AddModuleDelegate will be resolved via containers collaboration
    private let _addModuleDelegate = InjectedWeak<AddModuleDelegate>()
    var addModuleDelegate : AddModuleDelegate? { return _addModuleDelegate.value }
    
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
