//
//  AlarmSettingsViewController.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//

import UIKit

class AlarmSettingsViewController: UITableViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    var date: NSDate = NSDate()
    
    override func viewWillAppear(animated: Bool) {
        datePicker.setDate(date, animated: true)
    }
    
}