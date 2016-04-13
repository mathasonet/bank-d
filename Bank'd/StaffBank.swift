//
//  Currency.swift
//  Bank'd
//
//  Created by Mathew Haverty on 4/3/16.
//  Copyright © 2016 Matify. All rights reserved.
//

import UIKit

enum DollarOfType: Int {
  case One = 1
  case Two = 2
  case Five = 5
  case Ten = 10
  case Twenty = 20
  case Fifty = 50
  case Hundred = 100
  
  static let allValues = [One, Two, Five, Ten, Twenty, Fifty, Hundred]
}

enum CoinOfType: Double {
  case Penny = 0.01
  case Nickle = 0.05
  case Dime = 0.10
  case Quarter = 0.25
  case Fifty = 0.50
  
  static let allValues = [Penny, Nickle, Dime, Quarter, Fifty]
}

class StaffBank {
  private var _dollarBank: [DollarOfType: Int]!
  private var _coinBank: [CoinOfType: Int]!
  
  var dollarBank: [DollarOfType: Int] {
    return _dollarBank
  }
  
  var coinBank: [CoinOfType: Int] {
    return _coinBank
  }
  
  init(dollarBank: [DollarOfType: Int], coinBank: [CoinOfType: Int]) {
    self._dollarBank = dollarBank
    self._coinBank = coinBank
  }
  
  func totalAmount() -> Double {
    var totalBank = 0.0
    
    for (dollarAmount, dollarCount) in dollarBank {
      let calculation = dollarAmount.rawValue * dollarCount
      totalBank += Double(calculation)
    }
    
    for (coinAmount, coinCount) in coinBank {
      let calculation = coinAmount.rawValue * Double(coinCount)
      totalBank += calculation
    }
    
    return totalBank
  }
  
  func isNotEmpty() -> Bool {
    if self.totalAmount() > 0.0 {
      return true
    } else {
      return false
    }
  }
}