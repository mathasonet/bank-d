//
//  VC.swift
//  Bank'd
//
//  Created by Mathew Haverty on 4/2/16.
//  Copyright © 2016 Matify. All rights reserved.
//

import UIKit
import CoreData

class VC: UIViewController {
  
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
  var workingBank: NSManagedObject?
  var banks = [NSManagedObject]()
  
  var isNewRecord = true
  var statusBarHidden = false
  
  
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
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    
    scrollView.delegate = self
    scrollView.keyboardDismissMode = .Interactive
    
    guard let titleFont = UIFont(name: "FiraSans-Regular", size: 18) else {return}
    guard let buttonFont = UIFont(name: "FiraSans-Regular", size: 15) else {return}
    
    navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: titleFont]
    UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: buttonFont], forState: .Normal)
    self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: buttonFont], forState: .Normal)
    self.navigationItem.rightBarButtonItems?.forEach({ (Element) in
      Element.setTitleTextAttributes([NSFontAttributeName: buttonFont], forState: .Normal)
    })
  }
  
  override func viewDidLayoutSubviews() {
    scrollView.contentSize = view.frame.size
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if isNewRecord == false {

      if let useBank = workingBank {
        propogateTextFields(useBank)
        checkFieldValues()
        changeLabel()
      }
    }
    
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return statusBarHidden
  }
  
  override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
    return UIStatusBarAnimation.Slide
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
  
  @IBAction func onSavePressed(sender: UIBarButtonItem) {
    
    navigationController?.popViewControllerAnimated(true)
  }
  
  
  // MARK: Functions, Interface
  
  func propogateTextFields(fromBank: NSManagedObject) {
    for dollar in dollarFlds {
      
      var keyVal = String()
      
      switch dollar.fieldID {
      case "hundredDollar": keyVal = "dollarHundred"
      case "fiftyDollar": keyVal = "dollarFifty"
      case "twentyDollar": keyVal = "dollarTwenty"
      case "tenDollar": keyVal = "dollarTen"
      case "fiveDollar": keyVal = "dollarFive"
      case "twoDollar": keyVal = "dollarTwo"
      case "oneDollar": keyVal = "dollarOne"
      default: return
      }
      
      
      guard let value = fromBank.valueForKey(keyVal) else { return }
      dollar.text = String(value)
    }
    
    for coin in centFlds {
      
      var keyVal = String()
      
      switch coin.fieldID {
      case "fiftyCent": keyVal = "coinFifty"
      case "quarterCent": keyVal = "coinQuarter"
      case "tenCent": keyVal = "coinDime"
      case "fiveCent": keyVal = "coinNickle"
      case "oneCent": keyVal = "coinPenny"
      default: return
      }
      
      guard let value = fromBank.valueForKey(keyVal) else { return }
      coin.text = String(value)
    }
  }
  
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
    // FIXME: This is still letting empty records get saved
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

// MARK:- Protocol Conformance
// MARK: TextFieldDelegate
extension VC: UITextFieldDelegate {
  
  func textField(textField: UITextField,
                 shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    let inverseSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
    
    let components = string.componentsSeparatedByCharactersInSet(inverseSet)
    
    let filtered = components.joinWithSeparator("")
    
    return string == filtered
    
  }
}

// MARK: ScrollViewDelegate
extension VC: UIScrollViewDelegate {
  
}

// MARK: NavigationBarDelegate
extension VC: UINavigationBarDelegate {
  
}
