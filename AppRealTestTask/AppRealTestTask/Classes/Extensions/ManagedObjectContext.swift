//
//  ManagedObjectContext.swift
//  AppRealTestTask
//
//  Created by Roman Rybachenko on 6/13/19.
//  Copyright © 2019 Roman Rybachenko. All rights reserved.
//

import Foundation
import CoreData


extension NSManagedObjectContext {
    public func executeFetchRequest(request: NSFetchRequest<NSFetchRequestResult>) -> [AnyObject] {
        var result = [AnyObject]()
        do {
            result = try self.fetch(request)
        } catch let error as NSError {
            pl(error.localizedDescription)
        }
        return result
        
    }
}
