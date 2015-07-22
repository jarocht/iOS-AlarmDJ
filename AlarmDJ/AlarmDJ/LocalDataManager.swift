//
//  SettingsContainer.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//

import Foundation

class LocalDataManager {
    
    func loadSettings() -> SettingsContainer{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var tfh: Bool
        if defaults.valueForKey(Keys.twentyFourHour) != nil {
            tfh = defaults.valueForKey(Keys.twentyFourHour) as! Bool
        } else {
            tfh = false
        }
        
        var si: Int
        if defaults.valueForKey(Keys.snoozeInterval) != nil {
            si = defaults.valueForKey(Keys.snoozeInterval) as! Int
        } else {
            si = 9
        }
        
        var wz: String
        if defaults.valueForKey(Keys.weatherZip) != nil {
            wz = defaults.valueForKey(Keys.weatherZip) as! String
        } else {
            wz = "49428"
        }
        
        return SettingsContainer(twentyFourHour: tfh, snoozeInterval: si, weatherZip: wz)
    }
    
    func saveSettings(settingsContainer sc: SettingsContainer) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(sc.twentyFourHour, forKey: Keys.twentyFourHour)
        defaults.setValue(sc.snoozeInterval, forKey: Keys.snoozeInterval)
        defaults.setValue(sc.weatherZip, forKey: Keys.weatherZip)
        
        defaults.synchronize()
    }
    
    func loadAlarms() -> [Alarm] {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var alarms: [Alarm] = []
        
        var count: Int = 0
        if defaults.valueForKey(Keys.alarmCount) != nil {
            count = defaults.valueForKey(Keys.alarmCount) as! Int
        }
        
        var alarm: Alarm
        for var i = 0; i < count; i++ {
            var days: [Int] = [0,0,0,0,0,0,0]
            var time: NSDate = NSDate()
            var repeat: Bool = false
            var enabled: Bool = true
            
            if defaults.valueForKey("\(Keys.alarmDays)\(i)") != nil {
                days = defaults.valueForKey("\(Keys.alarmDays)\(i)") as! [Int]
            }
            if defaults.valueForKey("\(Keys.alarmTime)\(i)") != nil {
                time = defaults.valueForKey("\(Keys.alarmTime)\(i)") as! NSDate
            }
            if defaults.valueForKey("\(Keys.alarmRepeat)\(i)") != nil {
                repeat = defaults.valueForKey("\(Keys.alarmRepeat)\(i)") as! Bool
            }
            if defaults.valueForKey("\(Keys.alarmEnabled)\(i)") != nil {
                enabled = defaults.valueForKey("\(Keys.alarmEnabled)\(i)") as! Bool
            }
            
            alarms.append(Alarm(days: days, time: time, repeat: repeat, enabled: enabled))
        }
        
        return alarms
    }
    
    func saveAlarms(alarms a: [Alarm]){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(a.count, forKey: Keys.alarmCount)

        for var i = 0; i < a.count; i++ {
            defaults.setValue(a[i].days, forKey: "\(Keys.alarmDays)\(i)")
            defaults.setValue(a[i].time, forKey: "\(Keys.alarmTime)\(i)")
            defaults.setValue(a[i].repeat, forKey: "\(Keys.alarmRepeat)\(i)")
            defaults.setValue(a[i].enabled, forKey: "\(Keys.alarmEnabled)\(i)")
        }
        
        defaults.synchronize()
    }
}

class SettingsContainer {
    var twentyFourHour: Bool
    var snoozeInterval: Int
    var weatherZip: String
    
    convenience init(){
        self.init(twentyFourHour: false, snoozeInterval: 9, weatherZip: "49428")
    }
    
    init(twentyFourHour: Bool, snoozeInterval: Int, weatherZip: String){
        self.twentyFourHour = twentyFourHour
        self.snoozeInterval = snoozeInterval
        self.weatherZip = weatherZip
    }
}

class Alarm {
    var days: [Int]
    var time: NSDate
    var repeat: Bool
    var enabled: Bool
    
    init (days: [Int], time: NSDate, repeat: Bool, enabled: Bool) {
        self.days = days
        self.time = time
        self.repeat = repeat
        self.enabled = enabled
    }
}


struct Keys {
    static let twentyFourHour = "twentyFourHour"
    static let snoozeInterval = "snoozeInterval"
    static let weatherZip = "weatherZip"
    static let alarmCount = "alarmCount"
    static let alarmDays = "alarmDays_"
    static let alarmTime = "alarmTime_"
    static let alarmRepeat = "alarmRepeat_"
    static let alarmEnabled = "alarmEnabled_"
}