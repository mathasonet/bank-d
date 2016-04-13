//
//  BankCell.swift
//  Bank'd
//
//  Created by Mathew Haverty on 4/3/16.
//  Copyright © 2016 Matify. All rights reserved.
//

import UIKit

class BankCell: UITableViewCell {
  
  @IBOutlet weak var timestampLbl: UILabel!
  @IBOutlet weak var amountLbl: UILabel!
  
  var timeStamp: String {
    get {
      guard let text = timestampLbl.text else {
        return ""
      }
      return text
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

}
