//
//  VC.swift
//  Bank'd
//
//  Created by Mathew Haverty on 4/2/16.
//  Copyright © 2016 Matify. All rights reserved.
//

import UIKit

class VC: UIViewController, UITextFieldDelegate {
  
  // MARK: IBOutlets
  @IBOutlet weak var emptyLbl: UILabel!
  @IBOutlet weak var bankLbl: UILabel!
  @IBOutlet weak var bankAmtLbl: UILabel!
  
  @IBOutlet var dollarFlds: [CurrencyField]!
  @IBOutlet var centFlds: [CurrencyField]!
  
  // MARK: Properties, Stored
  let formatter = NSNumberFormatter()
  
  var dollarBank = [DollarOfType:Int?]()
  var coinBank = [CoinOfType:Int?]()
  var bank: Bank?
  
  // MARK: Properties, Computed
  
  
  // MARK: Functions, Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for dollar in dollarFlds {
      dollar.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    }
    
    for cent in centFlds {
      cent.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    }
    
    let tapRecognizer = UITapGestureRecognizer()
    tapRecognizer.addTarget(self, action: #selector(VC.didTapView))
    self.view.addGestureRecognizer(tapRecognizer)
    _ = UIColor(red:0.768627, green:0.862745, blue:0.945098, alpha:1.0)
  }
  
  func didTapView() {
    
    for dollar in dollarFlds {
      dollar.resignFirstResponder()
    }
    
    for cent in centFlds {
      cent.resignFirstResponder()
    }
  }
  
  // MARK: IBActions
  
  @IBAction func onClearPressed(sender: UIButton) {
    
    for dollar in dollarFlds {
      dollar.text = ""
    }
    
    for cent in centFlds {
      cent.text = ""
    }
    
    changeLabel()
    didTapView()
  }
  
  
  // MARK: Functions, Interface

  func checkFieldValues() {
    
    for field in dollarFlds {
      
      var keyVal: DollarOfType
      
      switch field.fieldID {
      case "hundredDollar": keyVal = .Hundred
      case "fiftyDollar": keyVal = .Fifty
      case "twentyDollar": keyVal = .Twenty
      case "tenDollar": keyVal = .Ten
      case "fiveDollar": keyVal = .Five
      case "twoDollar": keyVal = .Two
      case "oneDollar": keyVal = .One
      default: keyVal = .Empty
      }
      
      if let fieldVal = Int(field.text!) {
        dollarBank[keyVal] = fieldVal
      } else {
        dollarBank[keyVal] = 0
      }
      
    }
    
    for field in centFlds {
      
      var keyVal: CoinOfType
      
      switch field.fieldID {
      case "fiftyCent": keyVal = .Fifty
      case "quarterCent": keyVal = .Quarter
      case "tenCent": keyVal = .Dime
      case "fiveCent": keyVal = .Nickle
      case "oneCent": keyVal = .Penny
      default: keyVal = .Empty
      }
      
      if let fieldVal = Int(field.text!) {
        coinBank[keyVal] = fieldVal
      } else {
        coinBank[keyVal] = 0
      }
      
    }
    
    bank = Bank(dollarBank: dollarBank, coinBank: coinBank)
  }
  
  func changeLabel() {
    checkFieldValues()
    
    formatter.numberStyle = .CurrencyStyle
    
    if bank?.totalAmount() > 0.0 {
      emptyLbl.hidden = true
      bankLbl.hidden = false
      bankAmtLbl.hidden = false
      
      if let stringAmount = bank?.totalAmount(), let printAmount = formatter.stringFromNumber(stringAmount) {
        bankAmtLbl.text = "\(printAmount)"
      }
    } else {
      emptyLbl.hidden = false
      bankLbl.hidden = true
      bankAmtLbl.hidden = true
    }
  }
}
