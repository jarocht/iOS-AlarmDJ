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
    let ldm = LocalDataManager()
    var settings: SettingsContainer = SettingsContainer()
    var alarms: [Alarm] = []
    var timers: [NSTimer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       settings = ldm.loadSettings()
        
        var alarm = Alarm(days: [0,0,0,0,0,0,0], time: NSDate(), title: "title 1", snooze: true, repeat: false, enabled: true, ringtoneId: 1034)
        var alarm2 = Alarm(days: [1,1,1,1,1,1,1], time: NSDate(), title: "title 2", snooze: true, repeat: false, enabled: false, ringtoneId: 1034)
        //ldm.saveAlarms(alarms: [alarm, alarm2])

       alarms = ldm.loadAlarms()
    }
    
    override func viewWillAppear(animated: Bool) {
        alarms = ldm.loadAlarms()
        self.tableView.reloadData()
        setAlarmAlerts()
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
    
    
    @IBAction func alarmEnabledSwitched(sender: AnyObject) {
        let index = tableView.indexPathForCell(sender.superview?!.superview as! UITableViewCell)!.row
        alarms[index].enabled = (sender as! UISwitch).on
        ldm.saveAlarms(alarms: alarms)
        setAlarmAlerts()
    }
    
    func setAlarmAlerts() {
        for var i = 0; i < alarms.count; i++ {
            if alarms[i].enabled {
                var current = NSCalendar.currentCalendar().components((.CalendarUnitWeekday | .CalendarUnitHour | .CalendarUnitMinute), fromDate: NSDate())
                var target = NSCalendar.currentCalendar().components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: alarms[i].time)
                var tHour = target.hour
                var tMin = target.minute
                
                var days = getDaysUntil(current.weekday, alarm: alarms[i])
                
                var timeInSeconds: Int = -1
                if days == 0 {
                    if current.hour == tHour{
                        if current.minute < tMin{
                            var minutes = tMin - current.minute
                            timeInSeconds = minutes * 60
                        }
                    } else if current.hour < tHour{
                        //figure out hours and minutes
                        var hours = tHour - current.hour
                        var minutes = tMin - current.minute
                        timeInSeconds = (hours * 3600) + (minutes * 60)
                    }
                } else if days == 1 {
                    //Time till midnight + time till alarm
                    var fullHoursUntilMidnight = 23 - current.hour
                    var fullMinutesUntilMidnight = 60 - current.minute
                    var hours = fullHoursUntilMidnight + tHour
                    var minutes = fullMinutesUntilMidnight + tMin
                    timeInSeconds = (hours * 3600) + (minutes * 60)
                }
                
                if (timeInSeconds > 0){
                    var secondsUntilAlarm = NSTimeInterval(timeInSeconds)
                    println("setting alarm \(alarms[i].title) with \(timeInSeconds) seconds")
                    timers.append(NSTimer.scheduledTimerWithTimeInterval(secondsUntilAlarm, target: self, selector: "fireTimer:", userInfo: ["alarm" : alarms[i]], repeats: false))
                }
            }
        }
    }
    
    func getDaysUntil(fromWeekDay: Int, alarm: Alarm) -> Int {
        var count = 0
        for var i = fromWeekDay; i < 7; i++ {
            count++
            if alarm.days[i] == 1 {
                return count
            }
        }
        
        for var i = 0; i < fromWeekDay - 1; i++ {
            count++
            if alarm.days[i] == 1 {
                return count
            }
        }
        return 0
    }
    
    func fireTimer(timer: NSTimer) {
        var info = timer.userInfo as! Dictionary<String, AnyObject>
        var alarm = info["alarm"] as! Alarm
        timer.invalidate()
        self.performSegueWithIdentifier("AlarmAlertSegue", sender: alarm)
    }
}