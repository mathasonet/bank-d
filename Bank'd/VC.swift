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
  
  @IBOutlet var dollarFlds: [UITextField]!
  @IBOutlet var centFlds: [UITextField]!
  
  // MARK: Properties, Stored
  let formatter = NSNumberFormatter()
  
  var dollarBank = [DollarOfType:Int?]()
  var coinBank = [CoinOfType:Int?]()
  var bank: Bank?
  
  // let numberToolbar: UIToolbar = UIToolbar()
  
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
    
    for dollar in dollarFlds {
      dollar.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    }
    
    for cent in centFlds {
      cent.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
    }
    /*
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
    */
    
    let tapRecognizer = UITapGestureRecognizer()
    tapRecognizer.addTarget(self, action: #selector(VC.didTapView))
    self.view.addGestureRecognizer(tapRecognizer)
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
    
    if let hundredsValue = Int(dollarFlds[0].text!) {
      dollarBank[.Hundred] = hundredsValue
    } else {
      dollarBank[.Hundred] = 0
    }
    
    if let fiftysValue = Int(dollarFlds[1].text!) {
      dollarBank[.Fifty] = fiftysValue
    } else {
      dollarBank[.Fifty] = 0
    }
    
    if let twentysValue = Int(dollarFlds[2].text!) {
      dollarBank[.Twenty] = twentysValue
    } else {
      dollarBank[.Twenty] = 0
    }
    
    if let tensValue = Int(dollarFlds[3].text!) {
      dollarBank[.Ten] = tensValue
    } else {
      dollarBank[.Ten] = 0
    }
    
    if let fivesValue = Int(dollarFlds[4].text!) {
      dollarBank[.Five] = fivesValue
    } else {
      dollarBank[.Five] = 0
    }
    
    if let twosValue = Int(dollarFlds[5].text!) {
      dollarBank[.Two] = twosValue
    } else {
      dollarBank[.Two] = 0
    }
    
    if let onesValue = Int(dollarFlds[6].text!) {
      dollarBank[.One] = onesValue
    } else {
      dollarBank[.One] = 0
    }
    
    
    if let fiftyValue = Int(centFlds[0].text!) {
      coinBank[.Fifty] = fiftyValue
    } else {
      coinBank[.Fifty] = 0
    }
    
    if let quarterValue = Int(centFlds[1].text!) {
      coinBank[.Quarter] = quarterValue
    } else {
      coinBank[.Quarter] = 0
    }
    
    if let dimeValue = Int(centFlds[2].text!) {
      coinBank[.Dime] = dimeValue
    } else {
      coinBank[.Dime] = 0
    }
    
    if let nickleValue = Int(centFlds[3].text!) {
      coinBank[.Nickle] = nickleValue
    } else {
      coinBank[.Nickle] = 0
    }
    
    if let pennyValue = Int(centFlds[4].text!) {
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
