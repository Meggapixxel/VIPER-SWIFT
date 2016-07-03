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

class ListWireframe : NSObject, Router {
    var addWireframe : AddWireframe?
    let listPresenter : ListPresenter

    weak var listViewController : ListViewController?
    
    init(listPresenter: ListPresenter) {
        self.listPresenter = listPresenter
    }
    
    func presentAddInterface() {
        listViewController?.performSegueWithIdentifier("add", sender: nil)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        addWireframe?.prepareForSegue(segue)
    }
    
}
