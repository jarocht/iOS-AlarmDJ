//
//  ViewController.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {
    
    var settings: SettingsContainer = SettingsContainer()
    var alarms: [Alarm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ldm = LocalDataManager()
        
        settings = ldm.loadSettings()
        //settings.weatherZip = "49426"
        //ldm.saveSettings(settingsContainer: settings)
        
        var alarm = Alarm(days: [0,0,0,0,0,0,0], time: NSDate(), repeat: false, enabled: true)
        var alarm2 = Alarm(days: [1,1,1,1,1,1,1], time: NSDate(), repeat: false, enabled: false)
        //ldm.saveAlarms(alarms: [alarm, alarm2])

       alarms = ldm.loadAlarms()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: AlarmCell = self.tableView.dequeueReusableCellWithIdentifier("AlarmCell") as! AlarmCell
        var alarm: Alarm = alarms[indexPath.row]
        

        
        //cell.timeLabel.text! = alarm.time
        let comp = NSCalendar.currentCalendar().components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: alarm.time)
        
        if settings.twentyFourHour {
            cell.periodLabel.hidden = true
            cell.timeLabel.text! = "\(comp.hour):\(comp.minute)"
        } else {
            var time = comp.hour.toIntMax()
            cell.periodLabel.text! = time >= 12 ? "PM" : "AM"
            
            if time > 12{
                time = time - 12
            }
            
            cell.timeLabel.text! = "\(time):\(comp.minute)"
        }
        
        if alarm.days[0] == 1 {
            cell.sundayLabel.textColor = UIColor.greenColor()
        }
        if alarm.days[1] == 1 {
            cell.mondayLabel.textColor = UIColor.greenColor()
        }
        if alarm.days[2] == 1 {
            cell.tuesdayLabel.textColor = UIColor.greenColor()
        }
        if alarm.days[3] == 1 {
            cell.wednesdayLabel.textColor = UIColor.greenColor()
        }
        if alarm.days[4] == 1 {
            cell.thursdayLabel.textColor = UIColor.greenColor()
        }
        if alarm.days[5] == 1 {
            cell.fridayLabel.textColor = UIColor.greenColor()
        }
        if alarm.days[6] == 1 {
            cell.saturdayLabel.textColor = UIColor.greenColor()
        }
        
        cell.activeSwitch.on = alarm.enabled
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var view = segue.destinationViewController as! AlarmSettingsViewController

        if segue.identifier == "NewAlarmSegue" {
            
        } else if segue.identifier == "ExistingAlarmSegue" {
            let index = self.tableView.indexPathForSelectedRow()!.row
            view.date = alarms[index].time
        }
    }
}