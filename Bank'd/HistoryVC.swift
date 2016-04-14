//
//  HistoryVC.swift
//  Bank'd
//
//  Created by Mathew Haverty on 4/3/16.
//  Copyright © 2016 Matify. All rights reserved.
//

import UIKit
import CoreData

class HistoryVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var banks = [Bank]()
  var sentBank: StaffBank?
  
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
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if(segue.identifier == "showRowSegue") {
      let nextVC = (segue.destinationViewController as! VC)
      let cell = sender as! BankCell
      let selectedRow = tableView.indexPathForCell(cell)!.row
      nextVC.isNewRecord = false
      nextVC.workingBank = banks[selectedRow]
    }
  }

}


extension HistoryVC: UITableViewDelegate {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 45.0
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let selectedRow = banks[indexPath.row]
    sentBank = selectedRow.staffBank
  }
}


extension HistoryVC: UITableViewDataSource {
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
    switch editingStyle {
    case .Delete:
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let context = appDelegate.managedObjectContext
      context.deleteObject(banks[indexPath.row] as NSManagedObject)
      banks.removeAtIndex(indexPath.row)
      
      do {
        try context.save()
      } catch let err as NSError {
        print("This error: \(err), \(err.userInfo)")
      }
      
      self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    default: return
    }
  }

}
