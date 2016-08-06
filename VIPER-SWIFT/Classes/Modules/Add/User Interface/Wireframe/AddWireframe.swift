//
//  AddWireframe.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit

let AddViewControllerIdentifier = "AddViewController"

class AddWireframe : NSObject, UIViewControllerTransitioningDelegate {

    let addPresenter : AddPresenter
    var presentedViewController : UIViewController?
    
    init(addPresenter: AddPresenter) {
        self.addPresenter = addPresenter
    }
    
    func prepareForSegue(_ segue: UIStoryboardSegue) -> Bool {
        guard segue.identifier == "add" else { return false }

        let newViewController = segue.destination as! AddViewController
        newViewController.modalPresentationStyle = .custom
        newViewController.transitioningDelegate = self

        presentedViewController = newViewController
        addPresenter.configureUserInterfaceForPresentation(newViewController)

        return true
    }
    
    func dismissAddInterface() {
        presentedViewController?.dismiss(animated: true, completion: nil)
        presentedViewController = nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AddDismissalTransition()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AddPresentationTransition()
    }
}
