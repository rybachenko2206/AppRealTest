//
//  ValidationHelper.swift
//  AppRealTestTask
//
//  Created by Roman Rybachenko on 6/13/19.
//  Copyright © 2019 Roman Rybachenko. All rights reserved.
//

import Foundation


class ValidationHelper {
    
    class func nameValid(_ name: String?) -> Bool {
        guard let name = name,
            !name.isEmpty,
            name.count > 1  else {
                return false
        }
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        
        return true
    }
}
