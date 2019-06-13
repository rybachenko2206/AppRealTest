//
//  Person.swift
//  AppRealTestTask
//
//  Created by Roman Rybachenko on 6/13/19.
//  Copyright © 2019 Roman Rybachenko. All rights reserved.
//

import Foundation
import CoreData


extension Person: ManagedObjectType {
    static let entityName: String = "Person"
    
    static func newPerson(name: String, avatarName: String, context: NSManagedObjectContext) -> Person? {
        guard let entityDescr = NSEntityDescription.entity(forEntityName: Person.entityName, in: context) else { return nil }
        let person = Person(entity: entityDescr, insertInto: context)
        person.name = name
        person.avatarName = avatarName
        
        return person
    }
    
    static func allPersons(in context: NSManagedObjectContext) -> [Person] {
        let sortDescr = NSSortDescriptor(key: "name", ascending: true)
        let fRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Person.entityName)
        fRequest.sortDescriptors = [sortDescr]
        guard let result = context.executeFetchRequest(request: fRequest) as? [Person] else { return [] }
        return result
    }
}
