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

func configureContainer(container rootContainer: DependencyContainer) {
    Dip.logLevel = .Verbose

    //This is an example of a simplest definition:
    //DeviceClock is registered as implementation of Clock protocol in Singleton scope
    rootContainer.register(.Singleton) { DeviceClock() as Clock }
    
    //Or you can register concrete types
    rootContainer.register(.Singleton) { CoreDataStore() }

    //List module and add module should be connected through AddWireframe and ListPresenter
    //so we make them to collaborate to be able to share these instance
    //You can also do it manually referencing add module container in definitions of list module container,
    //but that is not possible with auto-wiring (as well as auto-inection) that we use for ListWireframe definition
    //Also containers collaboration can be used to share some base definitions
    //and to modularize yor configurations.
    listModule.collaborate(with: addModule, rootContainer)
    addModule.collaborate(with: listModule, rootContainer)
    
    //UI containers will be used to resolve dependencies of controllers 
    //(or other NSObject's)  created from storyboards if the conform to StoryboardInstantiatable
    DependencyContainer.uiContainers = [listModule, addModule]
}

//MARK: List module
let listModule = DependencyContainer() { container in
    //This is an example of auto-wiring - container will resolve factory arguments by itself
    let listWireframe = container.register(.WeakSingleton) { ListWireframe(listPresenter: $0)}
        .resolvingProperties { container, wireframe in
            //resolveDependencies block is usually used to resolve dependencies with property injection
            
            //As you will see below we register controller with a tag, so we have to use it
            //to inject the same controller that was created from a storyboard
            wireframe.listViewController = try container.resolve(tag: ListViewControllerIdentifier)
            wireframe.addWireframe = try container.resolve()
    }
    container.register(listWireframe, type: Router.self)

    //Alternatively we can explicitly resolve factory arguments
    //DataStore will be resolved from root container through containers collaboration
    container.register(.Shared) {
        try ListDataManager(
            //you can explicitly specify type to resolve instead of letting compiler to infer it
            dataStore: container.resolve() as CoreDataStore
        )
    }

    //Another example of auto-wiring definition but with passing initializer as a factory 
    //instead of calling it in closure
    let interactor = container.register(.Shared, factory: ListInteractor.init)
        .resolvingProperties { container, interactor in
            //While developing it is usefull to catch exceptions if something fails to resolve
            //For that use `try!` when calling container `resolve` method.
            //Otherwise the error will be just logged in the debugger.
            interactor.output = try! container.resolve()
    }
    //This is an example of type-forwarding. Previous definition (and thus instance resolved using it)
    //will be used to resolve `ListInteractorInput` type.
    container.register(interactor, type: ListInteractorInput.self)

    let presenter = container.register(.Shared, factory: ListPresenter.init)
        .resolvingProperties { container, presenter in
            presenter.listInteractor = try container.resolve()
            
            //This is an example of circular dependencies:
            //wireframe has a reference to presenter,
            //presenter has a reference to wireframe.
            //We inject presenter in wireframe with constructor injection,
            //so to inject wirefreme in presenter we need to use property injection
            presenter.listWireframe = try container.resolve()
            presenter.userInterface = try container.resolve(tag: ListViewControllerIdentifier)
    }
    //Another examples of type-forwarding
    container.register(presenter, type: ListInteractorOutput.self)
    container.register(presenter, type: ListModuleInterface.self)
    
    //This type will be resolved from add module through containers collaboration
    container.register(presenter, type: AddModuleDelegate.self)
    
    //This is an example of registering controller created from a storyboard.
    //For such controllers use the same tag as dipTag property (or nil) to register them.
    //Provided factory will be not called as controller is already instantiated from a storyboard.
    let controller = container.register(.Shared, tag: ListViewControllerIdentifier) { ListViewController() }
        .resolvingProperties { container, controller in
            //to use tag "ListViewController" to resolve dependencies graph we can use `container.context.tag`
            //but we don't do that because then list module will resolve one instance of AddWireframe
            //and then add module will resolve another instance of it instead of reusing the same instance
            controller.eventHandler = try container.resolve()
            controller.router = try container.resolve()
    }
    //we register ListViewController as ListViewInterface with the same tag
    //to be able to reuse instance created from storyboard
    container.register(controller, type: ListViewInterface.self, tag: ListViewControllerIdentifier)
}

//The only thing needed to inject in view controllers created from storyboards - to adopt StoryboardInstantiatable
extension ListViewController: StoryboardInstantiatable { }

//MARK: Add module
let addModule = DependencyContainer() { container in
    //AddWireframe is registered as Singleton to make it reusable between collaborating containers
    container.register(.WeakSingleton, factory: AddWireframe.init)
    
    container.register(.Shared) {
        try AddDataManager(
            //You can use weakly-typed methods to resolve components
            dataStore: container.resolve(CoreDataStore.self) as! DataStore
        )
    }
    container.register(.Shared, factory: AddInteractor.init)
    
    //AddPresenter makes extensive use of auto-injection to inject its dependencies with property injection.
    //We use Singleton scope for presenter because it will be first resolved by list module
    //when resolving ListWireframe that has dependency on AddWireframe that in turn depends on AddPresenter.
    //Shared scope reuses instances only while resolving single object graph,
    //in other words until the outermost call to `resolve` method returns.
    //When AddViewController is created later at runtime add module object graph will be resolved.
    //Because of that Shared scope will produce new AddPresenter (and it's dependencies)
    //With Singleton scope already created instance will be reused.
    let presenter = container.register(.WeakSingleton, factory: AddPresenter.init)
    container.register(presenter, type: AddModuleInterface.self)

    //To register controller with nil tag set dipTag in storyboard as Nil instead of String
    container.register(.Shared) { AddViewController() }
}

extension AddViewController: StoryboardInstantiatable { }
