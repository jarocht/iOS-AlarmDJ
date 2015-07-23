//
//  RingtoneSelectorViewController.swift
//  AlarmDJ
//
//  Created by X Code User on 7/23/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//

import UIKit

class RingtoneSelectorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var alarm: Alarm = Alarm()
    var alarmIndex: Int = -1
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let ringtoneStringData = ["Alarm", "Anticipate", "Bloom", "Calypso", "Choo Choo", "Descent", "Fanfare", "Ladder", "Minuet", "News Flash", "Noir", "Sherwood Forest", "Spell", "Suspense", "Telegraph", "Tiptoes", "Typewriters", "Update", "Vibrate", "New Mail", "Mail Sent", "Voicemail", "Received Message", "Sent Message", "Lock", "Tock"]
    let ringtoneValues = [1304,1305,1306,1320,1321,1322,1323,1324,1325,1326,1327,1328,1329,1330,1331,1332,1333,1334,1335,1336,4095,1000,1001,1002,1003,1004]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        var index = 0
        for var i = 0; i < ringtoneValues.count; i++ {
            if ringtoneValues[i] == alarm.ringtoneId {
                index = i
            }
        }
        pickerView.selectRow(index, inComponent: 0, animated: true)
        pickerView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ringtoneStringData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return ringtoneStringData[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        alarm.ringtoneId = ringtoneValues[row]
    }
    
    
    @IBAction func saveBtnClicked(sender: AnyObject) {
        var ldm = LocalDataManager()
        var alarms = ldm.loadAlarms()
        
        var alarm = Alarm(days: self.alarm.days, time: self.alarm.time, title: self.alarm.title, snooze: self.alarm.snooze, repeat: self.alarm.snooze, enabled: self.alarm.enabled, ringtoneId: self.alarm.ringtoneId)
        
        alarms[alarmIndex] = alarm
        
        ldm.saveAlarms(alarms: alarms)
        navigationController!.popViewControllerAnimated(true)
    }
}

/*

@IBAction func ringtonesButtonPressed(sender: UIButton) {
//Ringtone
let ringtone:String = self.ringtoneLabel.text!

var toneID:Int

switch ringtone {
case "Alarm":
toneID = 1304
case "Lock":
toneID = 1305
case "Tock":
toneID = 1306
case "Anticipate":
toneID = 1320
case "Bloom":
toneID = 1321
case "Calypso":
toneID = 1322
case "Choo Choo":
toneID = 1323
case "Descent":
toneID = 1324
case "Fanfare":
toneID = 1325
case "Ladder":
toneID = 1326
case "Minuet":
toneID = 1327
case "News Flash":
toneID = 1328
case "Noir":
toneID = 1329
case "Sherwood Forest":
toneID = 1330
case "Spell":
toneID = 1331
case "Suspense":
toneID = 1332
case "Telegraph":
toneID = 1333
case "Tiptoes":
toneID = 1334
case "Typewriters":
toneID = 1335
case "Update":
toneID = 1336
case "Vibrate":
toneID = 4095
case "New Mail":
toneID = 1000
case "Mail Sent":
toneID = 1001
case "Voicemail":
toneID = 1002
case "Received Message":
toneID = 1003
case "Sent Message":
toneID = 1004
default:
toneID = 1304
}

var toneIDSounf = UInt32(toneID)
AudioServicesPlaySystemSound(toneIDSounf)

}

*/
