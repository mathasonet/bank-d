//
//  HistoryVC.swift
//  Bank'd
//
//  Created by Mathew Haverty on 4/3/16.
//  Copyright © 2016 Matify. All rights reserved.
//

import UIKit
import CoreData

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var banks = [Bank]()
  
  let formatter = NSDateFormatter()
  let numFormatter = NSNumberFormatter()

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.delegate = self
    tableView.dataSource = self
    
    //title = "\"The List\""
    //tableView.registerClass(BankCell.self, forCellReuseIdentifier: "BankCell")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "Bank")
    let sort = NSSortDescriptor(key: "created", ascending: false)
    fetchRequest.sortDescriptors = [sort]
    
    do {
      let results = try managedContext.executeFetchRequest(fetchRequest)
      banks = results as! [Bank]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
    if let indexPath = self.tableView.indexPathForSelectedRow {
      self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("BankCell") as? BankCell {
      let bank = banks[indexPath.row]
      let amountVal = bank.staffBank.totalAmount()
      
      formatter.dateStyle = .LongStyle
      formatter.timeStyle = .MediumStyle
      numFormatter.numberStyle = .CurrencyStyle
      
      if let dateVal = bank.created {
        cell.timestampLbl.text = formatter.stringFromDate(dateVal)
        cell.amountLbl.text = numFormatter.stringFromNumber(amountVal)
        
      }
      return cell
    } else {
      return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return banks.count
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 45.0
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */
  
  @IBAction func backBtnPressed(sender: UIButton) {
    dismissViewControllerAnimated(true, completion: nil)
  }

}
