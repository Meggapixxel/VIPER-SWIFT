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
        print("creating \(type(of: self))")
    }
    deinit {
        print("deinit \(type(of: self))")
    }

    func today() -> Date {
        return Date()
    }
}
