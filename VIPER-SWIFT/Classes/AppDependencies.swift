//
//  AppDependencies.swift
//  VIPER TODO
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit
import DipUI

func configureContainer(container: DependencyContainer) {
    DependencyContainer.uiContainer = container
    
    container.register(.Singleton) { CoreDataStore() as DataStore }
    container.register(.Singleton) { DeviceClock() as Clock }
    container.register(.Singleton) { RootWireframe() }
    
    //List module
    container.register(.ObjectGraph) { ListDataManager(dataStore: $0) }
    
    let interactor = container.register(.ObjectGraph) { ListInteractor(dataManager: $0, clock: $1) }
        .resolveDependencies { container, interactor in
            interactor.output = try container.resolve()
    }
    
    container.register(interactor, type: ListInteractorInput.self)
    
    container.register(.Singleton) { ListWireframe(rootWireframe: $0, addWireframe: $1, listPresenter: $2) }
    
    let presenter = container.register(.ObjectGraph) { ListPresenter() }
        .resolveDependencies { container, presenter in
            presenter.listInteractor = try container.resolve()
            presenter.listWireframe = try container.resolve()
    }
    
    container.register(presenter, type: ListInteractorOutput.self)
    container.register(presenter, type: ListModuleInterface.self)
    container.register(presenter, type: AddModuleDelegate.self)
    container.register(presenter, type: Router.self)
    
    container.register(tag: "ListViewController", .ObjectGraph) { ListViewController() }
        .resolveDependencies { container, controller in
            controller.eventHandler = try container.resolve()
            controller.router = try container.resolve()
    }

    //Add module
    container.register(.ObjectGraph) { AddDataManager(dataStore: $0) }
    container.register(.ObjectGraph) { AddInteractor(addDataManager: $0) }
    container.register(.Singleton) { AddWireframe(addPresenter: $0) }

    container.register(.ObjectGraph) { AddPresenter() }
        .resolveDependencies { container, presenter in
            presenter.addModuleDelegate = try container.resolve()
    }
    
    container.register(tag: "AddViewController", .ObjectGraph) { AddViewController() }
}

extension ListViewController: StoryboardInstantiatable {}
extension AddViewController: StoryboardInstantiatable {}
