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
  
  var dollarBank = [DollarOfType:Int?]()
  var coinBank = [CoinOfType:Int?]()
  var bank: Bank?
  
  let numberToolbar: UIToolbar = UIToolbar()
  
  @IBOutlet weak var hundredDollarFld: UITextField!
  @IBOutlet weak var fiftyDollarFld: UITextField!
  @IBOutlet weak var twentyDollarFld: UITextField!
  @IBOutlet weak var tenDollarFld: UITextField!
  @IBOutlet weak var fiveDollarFld: UITextField!
  @IBOutlet weak var twoDollarFld: UITextField!
  @IBOutlet weak var oneDollarFld: UITextField!
  
  @IBOutlet weak var fiftyCentFld: UITextField!
  @IBOutlet weak var quarterCentFld: UITextField!
  @IBOutlet weak var dimeCentFld: UITextField!
  @IBOutlet weak var nickleCentFld: UITextField!
  @IBOutlet weak var pennyCentFld: UITextField!
  
  // MARK: Properties, Stored
  let formatter = NSNumberFormatter()
  // MARK: Properties, Computed
  
  
  // MARK: Functions, Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    /*
    numberToolbar.barStyle = UIBarStyle.Default
    numberToolbar.items=[
      UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(VC.textFieldShouldReturn(_:))),
      UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil),
      UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(VC.closeToolbar))
    ]
    
    numberToolbar.sizeToFit()
    
    hundredDollarFld.inputAccessoryView = numberToolbar
    fiftyDollarFld.inputAccessoryView = numberToolbar
    twentyDollarFld.inputAccessoryView = numberToolbar
    tenDollarFld.inputAccessoryView = numberToolbar
    fiveDollarFld.inputAccessoryView = numberToolbar
    twoDollarFld.inputAccessoryView = numberToolbar
    oneDollarFld.inputAccessoryView = numberToolbar
    
    fiftyCentFld.inputAccessoryView = numberToolbar
    quarterCentFld.inputAccessoryView = numberToolbar
    dimeCentFld.inputAccessoryView = numberToolbar
    nickleCentFld.inputAccessoryView = numberToolbar
    pennyCentFld.inputAccessoryView = numberToolbar
    */
    hundredDollarFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    fiftyDollarFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    twentyDollarFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    tenDollarFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    fiveDollarFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    twoDollarFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    oneDollarFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    
    fiftyCentFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    quarterCentFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    dimeCentFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    nickleCentFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    pennyCentFld.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    
    let tapRecognizer = UITapGestureRecognizer()
    tapRecognizer.addTarget(self, action: #selector(VC.didTapView))
    self.view.addGestureRecognizer(tapRecognizer)
  }
  
  func didTapView() {
    hundredDollarFld.resignFirstResponder()
    fiftyDollarFld.resignFirstResponder()
    twentyDollarFld.resignFirstResponder()
    tenDollarFld.resignFirstResponder()
    fiveDollarFld.resignFirstResponder()
    twoDollarFld.resignFirstResponder()
    oneDollarFld.resignFirstResponder()
    
    fiftyCentFld.resignFirstResponder()
    quarterCentFld.resignFirstResponder()
    dimeCentFld.resignFirstResponder()
    nickleCentFld.resignFirstResponder()
    pennyCentFld.resignFirstResponder()
  }
  
  // MARK: IBActions
  
  // MARK: Functions, Interface
  /*
  func closeToolbar() {
    self.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == hundredDollarFld {
      textField.resignFirstResponder()
      fiftyDollarFld.becomeFirstResponder()
    }
    return true
  }
  */
  func checkFieldValues() {
    
    if let hundredsValue = Int(hundredDollarFld.text!) {
      dollarBank[.Hundred] = hundredsValue
    } else {
      dollarBank[.Hundred] = 0
    }
    
    if let fiftysValue = Int(fiftyDollarFld.text!) {
      dollarBank[.Fifty] = fiftysValue
    } else {
      dollarBank[.Fifty] = 0
    }
    
    if let twentysValue = Int(twentyDollarFld.text!) {
      dollarBank[.Twenty] = twentysValue
    } else {
      dollarBank[.Twenty] = 0
    }
    
    if let tensValue = Int(tenDollarFld.text!) {
      dollarBank[.Ten] = tensValue
    } else {
      dollarBank[.Ten] = 0
    }
    
    if let fivesValue = Int(fiveDollarFld.text!) {
      dollarBank[.Five] = fivesValue
    } else {
      dollarBank[.Five] = 0
    }
    
    if let twosValue = Int(twoDollarFld.text!) {
      dollarBank[.Two] = twosValue
    } else {
      dollarBank[.Two] = 0
    }
    
    if let onesValue = Int(oneDollarFld.text!) {
      dollarBank[.One] = onesValue
    } else {
      dollarBank[.One] = 0
    }
    
    
    if let fiftyValue = Int(fiftyCentFld.text!) {
      coinBank[.Fifty] = fiftyValue
    } else {
      coinBank[.Fifty] = 0
    }
    
    if let quarterValue = Int(quarterCentFld.text!) {
      coinBank[.Quarter] = quarterValue
    } else {
      coinBank[.Quarter] = 0
    }
    
    if let dimeValue = Int(dimeCentFld.text!) {
      coinBank[.Dime] = dimeValue
    } else {
      coinBank[.Dime] = 0
    }
    
    if let nickleValue = Int(nickleCentFld.text!) {
      coinBank[.Nickle] = nickleValue
    } else {
      coinBank[.Nickle] = 0
    }
    
    if let pennyValue = Int(pennyCentFld.text!) {
      coinBank[.Penny] = pennyValue
    } else {
      coinBank[.Penny] = 0
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
      
      print(bank?.totalAmount())
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
