//
//  AlarmSettingsViewController.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//

import UIKit

class AlarmSettingsViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var sundayBtn: UIButton!
    @IBOutlet weak var mondayBtn: UIButton!
    @IBOutlet weak var tuesdayBtn: UIButton!
    @IBOutlet weak var wednesdayBtn: UIButton!
    @IBOutlet weak var thursdayBtn: UIButton!
    @IBOutlet weak var fridayBtn: UIButton!
    @IBOutlet weak var saturdayBtn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var snoozeEnabledBtn: UISwitch!
    @IBOutlet weak var repeatEnabledBtn: UISwitch!
    @IBOutlet weak var deleteAlarmBtn: UIButton!
    
    var alarmIndex: Int = -1
    var alarm: Alarm = Alarm()
    
    override func viewDidLoad() {
        self.titleTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        datePicker.setDate(self.alarm.time, animated: true)
        titleTextField.text! = self.alarm.title
        sundayBtn.selected = alarm.days[0] == 1
        mondayBtn.selected = alarm.days[1] == 1
        tuesdayBtn.selected = alarm.days[2] == 1
        wednesdayBtn.selected = alarm.days[3] == 1
        thursdayBtn.selected = alarm.days[4] == 1
        fridayBtn.selected = alarm.days[5] == 1
        saturdayBtn.selected = alarm.days[6] == 1
        deleteAlarmBtn.hidden = alarmIndex == -1
        snoozeEnabledBtn.on = alarm.snooze
        repeatEnabledBtn.on = alarm.repeat
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectAlarmRingtone" {
            saveAlarms()
            var view = segue.destinationViewController as! RingtoneSelectorViewController
            view.alarm = self.alarm
            view.alarmIndex = self.alarmIndex
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func saveAlarms() {
        var ldm = LocalDataManager()
        var alarms = ldm.loadAlarms()
        
        var alarm = Alarm(days: self.alarm.days, time: datePicker.date, title: titleTextField.text!, snooze: snoozeEnabledBtn.on, repeat: snoozeEnabledBtn.on, enabled: self.alarm.enabled, ringtoneId: self.alarm.ringtoneId)
        
        if (alarmIndex < 0){
            alarms.append(alarm)
            alarmIndex = alarms.count - 1
        } else {
            alarms[alarmIndex] = alarm
        }
        
        ldm.saveAlarms(alarms: alarms)
    }

    @IBAction func saveBtnClicked(sender: AnyObject) {
        saveAlarms()
        navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func sundayBtnClicked(sender: AnyObject) {
        alarm.days[0] = sundayBtn.selected ? 0 : 1
        sundayBtn.selected = alarm.days[0] == 1
    }
   
    @IBAction func mondayBtnClicked(sender: AnyObject) {
        alarm.days[1] = mondayBtn.selected ? 0 : 1
        mondayBtn.selected = alarm.days[1] == 1
    }
    
    @IBAction func tuesdayBtnClicked(sender: AnyObject) {
        alarm.days[2] = tuesdayBtn.selected ? 0 : 1
        tuesdayBtn.selected = alarm.days[2] == 1
    }
    
    @IBAction func wednesdayBtnClicked(sender: AnyObject) {
        alarm.days[3] = wednesdayBtn.selected ? 0 : 1
        wednesdayBtn.selected = alarm.days[3] == 1
    }
    
    @IBAction func thursdayBtnClicked(sender: AnyObject) {
        alarm.days[4] = thursdayBtn.selected ? 0 : 1
        thursdayBtn.selected = alarm.days[4] == 1
    }
    
    @IBAction func fridayBtnClicked(sender: AnyObject) {
        alarm.days[5] = fridayBtn.selected ? 0 : 1
        fridayBtn.selected = alarm.days[5] == 1
    }
    
    @IBAction func saturdayBtnClicked(sender: AnyObject) {
        alarm.days[6] = saturdayBtn.selected ? 0 : 1
        saturdayBtn.selected = alarm.days[6] == 1
    }
    @IBAction func deleteAlarmBtnClicked(sender: AnyObject) {
        var ldm = LocalDataManager()
        var alarms = ldm.loadAlarms()
        alarms.removeAtIndex(alarmIndex)
        ldm.saveAlarms(alarms: alarms)
        navigationController!.popViewControllerAnimated(true)
    }
}