//
//  AlarmCell.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//

import UIKit

class AlarmCell: UITableViewCell{
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var pmLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    @IBOutlet weak var activeSwitch: UISwitch!
    /*@IBAction func activeSwitchClicked(sender: AnyObject) {
        let index = (self.superview?.superview as! UITableView).indexPathForCell(self)!.row
        var ldm = LocalDataManager()
        var alarms = ldm.loadAlarms()
        alarms[index].enabled = activeSwitch.on
        ldm.saveAlarms(alarms: alarms)
    }*/
}