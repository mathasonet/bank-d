//
//  Bank.swift
//  Bank'd
//
//  Created by Mathew Haverty on 4/13/16.
//  Copyright © 2016 Matify. All rights reserved.
//

import Foundation
import CoreData

class Bank: NSManagedObject {
  
  override func awakeFromInsert() {
    super.awakeFromInsert()
    
    self.created = NSDate()
    self.modified = NSDate()
  }
}
