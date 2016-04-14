//
//  VC.swift
//  Bank'd
//
//  Created by Mathew Haverty on 4/2/16.
//  Copyright © 2016 Matify. All rights reserved.
//

import UIKit
import CoreData

class VC: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UINavigationBarDelegate {
  
  // MARK: IBOutlets
  @IBOutlet weak var emptyLbl: UILabel!
  @IBOutlet weak var bankLbl: UILabel!
  @IBOutlet weak var bankAmtLbl: UILabel!
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet var dollarFlds: [CurrencyField]!
  @IBOutlet var centFlds: [CurrencyField]!
  
  // MARK: Properties, Stored
  let formatter = NSNumberFormatter()
  
  var dollarBank = [DollarOfType:Int]()
  var coinBank = [CoinOfType:Int]()
  var staffBank: StaffBank?
  var banks = [NSManagedObject]()
  
  var statusBarHidden = false
  
  // MARK: Properties, Computed
  
  
  // MARK: Functions, Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for dollar in dollarFlds {
      dollar.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
      dollar.delegate = self
    }
    
    for cent in centFlds {
      cent.addTarget(self, action: #selector(VC.changeLabel), forControlEvents: .EditingChanged)
      cent.delegate = self
    }
    
    let tapRecognizer = UITapGestureRecognizer()
    tapRecognizer.addTarget(self, action: #selector(VC.didTapView))
    self.view.addGestureRecognizer(tapRecognizer)
    _ = UIColor(red:0.768627, green:0.862745, blue:0.945098, alpha:1.0)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    
    scrollView.delegate = self
    
    scrollView.keyboardDismissMode = .Interactive
  }
  
  override func viewDidLayoutSubviews() {
    scrollView.contentSize = view.frame.size
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    //let barButton = UIBarButtonItem.appearance()
    
    guard let titleFont = UIFont(name: "FiraSans-Regular", size: 18) else {return}
    guard let buttonFont = UIFont(name: "FiraSans-Regular", size: 15) else {return}
    
    navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: titleFont]
    //UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: titleFont]
    UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: buttonFont], forState: .Normal)
    
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return statusBarHidden
  }
  
  override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
    return UIStatusBarAnimation.Slide
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let inverseSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
    
    let components = string.componentsSeparatedByCharactersInSet(inverseSet)
    
    let filtered = components.joinWithSeparator("")
    
    return string == filtered
  }
  
  override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
    if action == #selector(NSObject.paste(_:)) {
      return false
    }
    
    return super.canPerformAction(action, withSender: sender)
  }
  
  func keyboardWillShow(notification: NSNotification) {
    
    if let userInfo = notification.userInfo {
      let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
      let extra = emptyLbl.frame.size.height + 12.0
      let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + extra, 0.0)
      self.scrollView.contentInset = contentInsets
      self.scrollView.scrollIndicatorInsets = contentInsets
      
      if view.frame.size.height <= 500.0 {
        let scrollPoint = CGPointMake(0, emptyLbl.frame.origin.y - keyboardSize.height)
        scrollView.setContentOffset(scrollPoint, animated: true)
        hideStatusBar(true)
      }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    
    let contentInsets = UIEdgeInsetsZero
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
    
    hideStatusBar(false)
  }
  
  func hideStatusBar(toggle: Bool) {
    self.statusBarHidden = toggle
    self.setNeedsStatusBarAppearanceUpdate()
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
  
  @IBAction func onClearPressed(sender: AnyObject) {
    
    for dollar in dollarFlds {
      dollar.text = ""
    }
    
    for cent in centFlds {
      cent.text = ""
    }
    
    changeLabel()
    didTapView()
  }
  
  @IBAction func onPlusPressed(sender: UIBarButtonItem) {
    checkFieldValues()
    saveTextFields()
    onClearPressed(self)
  }
  
  // MARK: Functions, Interface
  
  func saveTextFields() {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    guard let entity = NSEntityDescription.entityForName("Bank", inManagedObjectContext: managedContext) else {
      return
    }
    
    let oneBank = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
    
    guard let staffBank = staffBank else {
      return
    }
    
    if staffBank.isNotEmpty() {
      
      for dollar in staffBank.dollarBank {
        
        var keyVal = String()
        
        switch dollar.0 {
        case .Hundred: keyVal = "dollarHundred"
        case .Fifty: keyVal = "dollarFifty"
        case .Twenty: keyVal = "dollarTwenty"
        case .Ten: keyVal = "dollarTen"
        case .Five: keyVal = "dollarFive"
        case .Two: keyVal = "dollarTwo"
        case .One: keyVal = "dollarOne"
        }
        
        oneBank.setValue(dollar.1, forKey: keyVal)

      }
      
      for coin in staffBank.coinBank {
        
        var keyVal = String()
        
        switch coin.0 {
        case .Fifty: keyVal = "coinFifty"
        case .Quarter: keyVal = "coinQuarter"
        case .Dime: keyVal = "coinDime"
        case .Nickle: keyVal = "coinNickle"
        case .Penny: keyVal = "coinPenny"
        }
        
        oneBank.setValue(coin.1, forKey: keyVal)
        
      }
      
      let alertController = UIAlertController(title: "Record Saved!", message: nil, preferredStyle: .Alert)
      
      let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
      
      alertController.addAction(okAction)
      self.didTapView()
      
      do {
        try managedContext.save()
        banks.append(oneBank)
        self.presentViewController(alertController, animated: true) {}
      } catch let err as NSError {
        print("Could not save \(err), \(err.userInfo)")
      }
    }
    
  }

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
      default: return
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
      default: return
      }
      
      if let fieldVal = Int(field.text!) {
        coinBank[keyVal] = fieldVal
      } else {
        coinBank[keyVal] = 0
      }
      
    }
    
    staffBank = StaffBank(dollarBank: dollarBank, coinBank: coinBank)
  }
  
  func changeLabel() {
    checkFieldValues()
    
    formatter.numberStyle = .CurrencyStyle
    
    if staffBank?.totalAmount() > 0.0 {
      emptyLbl.hidden = true
      bankLbl.hidden = false
      bankAmtLbl.hidden = false
      
      if let stringAmount = staffBank?.totalAmount(), let printAmount = formatter.stringFromNumber(stringAmount) {
        bankAmtLbl.text = "\(printAmount)"
      }
    } else {
      emptyLbl.hidden = false
      bankLbl.hidden = true
      bankAmtLbl.hidden = true
    }
  }
}
