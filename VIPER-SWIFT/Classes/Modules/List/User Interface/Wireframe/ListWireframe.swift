//
//  ListWireframe.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/5/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit
import Dip

let ListViewControllerIdentifier = "ListViewController"

class ListWireframe : NSObject {
    let addWireframe : AddWireframe
    let listPresenter : ListPresenter
    let rootWireframe : RootWireframe

    private let _listViewController = InjectedWeak<ListViewController>(tag: ListViewControllerIdentifier)
    var listViewController : ListViewController? { return _listViewController.value }
    
    init(rootWireframe: RootWireframe, addWireframe: AddWireframe, listPresenter: ListPresenter) {
        self.rootWireframe = rootWireframe
        self.addWireframe = addWireframe
        self.listPresenter = listPresenter
    }
    
    func presentAddInterface() {
        listViewController?.performSegueWithIdentifier("add", sender: nil)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        addWireframe.prepareForSegue(segue)
    }
    
}
