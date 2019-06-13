//
//  Utilities.swift
//  AppRealTestTask
//
//  Created by Roman Rybachenko on 6/13/19.
//  Copyright © 2019 Roman Rybachenko. All rights reserved.
//

import Foundation

struct Utilities {
    let kAppWasOpened = "appWasOpened"
    
    var appWasOpened: Bool {
        get {
            return UserDefaults.standard.value(forKey: kAppWasOpened) as? Bool ?? false
        } set {
            UserDefaults.standard.set(newValue, forKey: kAppWasOpened)
        }
    }
}
