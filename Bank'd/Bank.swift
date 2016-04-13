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
  
  var dollarBank = [DollarOfType:Int]()
  var coinBank = [CoinOfType:Int]()
  
  //let staffBank = StaffBank(dollarBank: dollarBank, coinBank: coinBank)
  
  var staffBank: StaffBank {
    get {
      dollarBank[.Hundred] = Int(self.dollarHundred!)
      dollarBank[.Fifty] = Int(self.dollarFifty!)
      dollarBank[.Twenty] = Int(self.dollarTwenty!)
      dollarBank[.Ten] = Int(self.dollarTen!)
      dollarBank[.Five] = Int(self.dollarFive!)
      dollarBank[.Two] = Int(self.dollarTwo!)
      dollarBank[.One] = Int(self.dollarOne!)
      
      coinBank[.Fifty] = Int(self.coinFifty!)
      coinBank[.Quarter] = Int(self.coinQuarter!)
      coinBank[.Dime] = Int(self.coinDime!)
      coinBank[.Nickle] = Int(self.coinNickle!)
      coinBank[.Penny] = Int(self.coinPenny!)
      
      
      return StaffBank(dollarBank: dollarBank, coinBank: coinBank)
    }
  }
}
