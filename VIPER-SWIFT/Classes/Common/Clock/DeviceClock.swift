//
//  DeviceClock.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation

class DeviceClock : NSObject, Clock {
    override init() {
        print("creating \(self.dynamicType)")
    }
    deinit {
        print("deinit \(self.dynamicType)")
    }

    func today() -> NSDate {
        return NSDate()
    }
}
