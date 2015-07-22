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
    var date: NSDate = NSDate()
    
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
    
    var days: [Int] = [0,0,0,0,0,0,0]
    var alarmIndex: Int = -1
    
    override func viewDidLoad() {
        self.titleTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        datePicker.setDate(date, animated: true)
        sundayBtn.selected = days[0] == 1
        mondayBtn.selected = days[1] == 1
        tuesdayBtn.selected = days[2] == 1
        wednesdayBtn.selected = days[3] == 1
        thursdayBtn.selected = days[4] == 1
        fridayBtn.selected = days[5] == 1
        saturdayBtn.selected = days[6] == 1
        deleteAlarmBtn.hidden = alarmIndex == -1
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    @IBAction func saveBtnClicked(sender: AnyObject) {
        var ldm = LocalDataManager()
        var alarms = ldm.loadAlarms()
        var alarm = Alarm(days: days, time: NSDate(), repeat: snoozeEnabledBtn.on, enabled: true)
        
        if (alarmIndex < 0){
            alarms.append(alarm)
        } else {
            alarms[alarmIndex] = alarm
        }
        
        ldm.saveAlarms(alarms: alarms)
        navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func sundayBtnClicked(sender: AnyObject) {
        days[0] = sundayBtn.selected ? 0 : 1
        sundayBtn.selected = days[0] == 1
    }
   
    @IBAction func mondayBtnClicked(sender: AnyObject) {
        days[1] = mondayBtn.selected ? 0 : 1
        mondayBtn.selected = days[1] == 1
    }
    
    @IBAction func tuesdayBtnClicked(sender: AnyObject) {
        days[2] = tuesdayBtn.selected ? 0 : 1
        tuesdayBtn.selected = days[2] == 1
    }
    
    @IBAction func wednesdayBtnClicked(sender: AnyObject) {
        days[3] = wednesdayBtn.selected ? 0 : 1
        wednesdayBtn.selected = days[3] == 1
    }
    
    @IBAction func thursdayBtnClicked(sender: AnyObject) {
        days[4] = thursdayBtn.selected ? 0 : 1
        thursdayBtn.selected = days[4] == 1
    }
    
    @IBAction func fridayBtnClicked(sender: AnyObject) {
        days[5] = fridayBtn.selected ? 0 : 1
        fridayBtn.selected = days[5] == 1
    }
    
    @IBAction func saturdayBtnClicked(sender: AnyObject) {
        days[6] = saturdayBtn.selected ? 0 : 1
        saturdayBtn.selected = days[6] == 1
    }
    @IBAction func deleteAlarmBtnClicked(sender: AnyObject) {
        var ldm = LocalDataManager()
        var alarms = ldm.loadAlarms()
        alarms.removeAtIndex(alarmIndex)
        ldm.saveAlarms(alarms: alarms)
        navigationController!.popViewControllerAnimated(true)
    }
}