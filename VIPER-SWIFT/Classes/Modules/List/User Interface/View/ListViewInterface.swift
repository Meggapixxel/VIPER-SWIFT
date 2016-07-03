//
//  ListViewInterface.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/5/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation

protocol ListViewInterface: class {
    func showNoContentMessage()
    func showUpcomingDisplayData(data: UpcomingDisplayData)
    func reloadEntries ()
}
    

