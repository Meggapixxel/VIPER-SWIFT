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
    
    func prepareForSegue(segue: UIStoryboardSegue) -> Bool {
        guard segue.identifier == "add" else { return false }

        let newViewController = segue.destinationViewController as! AddViewController
        newViewController.modalPresentationStyle = .Custom
        newViewController.transitioningDelegate = self

        presentedViewController = newViewController
        addPresenter.configureUserInterfaceForPresentation(newViewController)

        return true
    }
    
    func dismissAddInterface() {
        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        presentedViewController = nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AddDismissalTransition()
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AddPresentationTransition()
    }
}
