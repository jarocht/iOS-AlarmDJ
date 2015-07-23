//
//  ViewController.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {
    
    @IBOutlet var alarmTableView: UITableView!
    var settings: SettingsContainer = SettingsContainer()
    var alarms: [Alarm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ldm = LocalDataManager()
        
        settings = ldm.loadSettings()
        //settings.weatherZip = "49426"
        //ldm.saveSettings(settingsContainer: settings)
        
        var alarm = Alarm(days: [0,0,0,0,0,0,0], time: NSDate(), title: "title 1", snooze: true, repeat: false, enabled: true, ringtoneId: 1034)
        var alarm2 = Alarm(days: [1,1,1,1,1,1,1], time: NSDate(), title: "title 2", snooze: true, repeat: false, enabled: false, ringtoneId: 1034)
        //ldm.saveAlarms(alarms: [alarm, alarm2])

       alarms = ldm.loadAlarms()
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        alarms = LocalDataManager().loadAlarms()
        var cell: AlarmCell = self.tableView.dequeueReusableCellWithIdentifier("AlarmCell") as! AlarmCell
        var alarm: Alarm = alarms[indexPath.row]
        
        //cell.timeLabel.text! = alarm.time
        let comp = NSCalendar.currentCalendar().components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: alarm.time)
        
        if settings.twentyFourHour {
            cell.amLabel.hidden = true
            cell.pmLabel.hidden = true
            var time = parseTime(comp.hour, min: comp.minute)
            cell.timeLabel.text! = "\(time.hour):\(time.min)"
        } else {
            var hourTime: Int = ("\(comp.hour)").toInt()!
            cell.amLabel.hidden = hourTime >= 12
            cell.pmLabel.hidden = !cell.amLabel.hidden
            
            if hourTime > 12{
                hourTime = hourTime - 12
            }
            var time = parseTime(hourTime, min: comp.minute)
            
            cell.timeLabel.text! = "\(time.hour):\(time.min)"
        }
        
        cell.sundayLabel.textColor = alarm.days[0] == 1 ? UIColor.greenColor() : UIColor.blackColor()
        cell.mondayLabel.textColor = alarm.days[1] == 1 ? UIColor.greenColor() : UIColor.blackColor()
        cell.tuesdayLabel.textColor = alarm.days[2] == 1 ? UIColor.greenColor() : UIColor.blackColor()
        cell.wednesdayLabel.textColor = alarm.days[3] == 1 ? UIColor.greenColor() : UIColor.blackColor()
        cell.thursdayLabel.textColor = alarm.days[4] == 1 ? UIColor.greenColor() : UIColor.blackColor()
        cell.fridayLabel.textColor = alarm.days[5] == 1 ? UIColor.greenColor() : UIColor.blackColor()
        cell.saturdayLabel.textColor = alarm.days[6] == 1 ? UIColor.greenColor() : UIColor.blackColor()
        
        cell.titleLabel.text! = alarm.title
        cell.activeSwitch.on = alarm.enabled
        
        return cell
    }
    
    func parseTime(hour: Int, min: Int) -> (hour: String, min: String){
        var min: String = "\(min)"
        if count(min) < 2 {
            min = "0\(min)"
        }
        
        var hour: String = "\(hour)"
        if count(hour) < 2 {
            hour = "0\(hour)"
        }
        
        return (hour, min)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewAlarmSegue" {
            //Do nothing special
        } else if segue.identifier == "ExistingAlarmSegue" {
            let view = segue.destinationViewController as! AlarmSettingsViewController
            let index = self.tableView.indexPathForSelectedRow()!.row
            view.alarm = alarms[index]
            view.alarmIndex = index
        }
    }
}