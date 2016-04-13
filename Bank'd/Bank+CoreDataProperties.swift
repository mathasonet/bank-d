//
//  Bank+CoreDataProperties.swift
//  Bank'd
//
//  Created by Mathew Haverty on 4/13/16.
//  Copyright © 2016 Matify. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Bank {

    @NSManaged var created: NSDate?
    @NSManaged var modified: NSDate?
    @NSManaged var dollarHundred: NSNumber?
    @NSManaged var dollarFifty: NSNumber?
    @NSManaged var dollarTwenty: NSNumber?
    @NSManaged var dollarTen: NSNumber?
    @NSManaged var dollarFive: NSNumber?
    @NSManaged var dollarTwo: NSNumber?
    @NSManaged var dollarOne: NSNumber?
    @NSManaged var coinFifty: NSNumber?
    @NSManaged var coinQuarter: NSNumber?
    @NSManaged var coinDime: NSNumber?
    @NSManaged var coinNickle: NSNumber?
    @NSManaged var coinPenny: NSNumber?

}
