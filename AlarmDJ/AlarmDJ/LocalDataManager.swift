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
        
        var tfh: Bool = false
        if defaults.valueForKey(Keys.twentyFourHour) != nil {
            tfh = defaults.valueForKey(Keys.twentyFourHour) as! Bool
        }
        var si: Int = 9
        if defaults.valueForKey(Keys.snoozeInterval) != nil {
            si = defaults.valueForKey(Keys.snoozeInterval) as! Int
        }
        var wz: String = "49428"
        if defaults.valueForKey(Keys.weatherZip) != nil {
            wz = defaults.valueForKey(Keys.weatherZip) as! String
        }
        var nq: String = "Apple"
        if defaults.valueForKey(Keys.newsQuery) != nil {
            nq = defaults.valueForKey(Keys.newsQuery) as! String
        }
        var mg: String = "Country"
        if defaults.valueForKey(Keys.musicGenre) != nil {
            mg = defaults.valueForKey(Keys.musicGenre) as! String
        }
        
        return SettingsContainer(twentyFourHour: tfh, snoozeInterval: si, weatherZip: wz, newsQuery: nq, musicGenre: mg)
    }
    
    func saveSettings(settingsContainer sc: SettingsContainer) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(sc.twentyFourHour, forKey: Keys.twentyFourHour)
        defaults.setValue(sc.snoozeInterval, forKey: Keys.snoozeInterval)
        defaults.setValue(sc.weatherZip, forKey: Keys.weatherZip)
        defaults.setValue(sc.newsQuery, forKey: Keys.newsQuery)
        defaults.setValue(sc.musicGenre, forKey: Keys.musicGenre)
        
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
            var title: String = ""
            var snooze: Bool = false
            var repeat: Bool = false
            var enabled: Bool = true
            var ringtoneId: Int = 1304
            
            if defaults.valueForKey("\(Keys.alarmDays)\(i)") != nil {
                days = defaults.valueForKey("\(Keys.alarmDays)\(i)") as! [Int]
            }
            if defaults.valueForKey("\(Keys.alarmTime)\(i)") != nil {
                time = defaults.valueForKey("\(Keys.alarmTime)\(i)") as! NSDate
            }
            if defaults.valueForKey("\(Keys.alarmTitle)\(i)") != nil {
                title = defaults.valueForKey("\(Keys.alarmTitle)\(i)") as! String
            }
            if defaults.valueForKey("\(Keys.alarmSnooze)\(i)") != nil {
                snooze = defaults.valueForKey("\(Keys.alarmSnooze)\(i)") as! Bool
            }
            if defaults.valueForKey("\(Keys.alarmRepeat)\(i)") != nil {
                repeat = defaults.valueForKey("\(Keys.alarmRepeat)\(i)") as! Bool
            }
            if defaults.valueForKey("\(Keys.alarmEnabled)\(i)") != nil {
                enabled = defaults.valueForKey("\(Keys.alarmEnabled)\(i)") as! Bool
            }
            if defaults.valueForKey("\(Keys.alarmRingtoneId)\(i)") != nil {
                ringtoneId = defaults.valueForKey("\(Keys.alarmRingtoneId)\(i)") as! Int
            }
            
            alarms.append(Alarm(days: days, time: time, title: title, snooze: snooze, repeat: repeat, enabled: enabled, ringtoneId: ringtoneId))
        }
        
        return alarms
    }
    
    func saveAlarms(alarms a: [Alarm]){
        let defaults = NSUserDefaults.standardUserDefaults()
        println("saving \(a.count) alarms")
        defaults.setValue(a.count, forKey: Keys.alarmCount)

        for var i = 0; i < a.count; i++ {
            defaults.setValue(a[i].days, forKey: "\(Keys.alarmDays)\(i)")
            defaults.setValue(a[i].time, forKey: "\(Keys.alarmTime)\(i)")
            defaults.setValue(a[i].title, forKey: "\(Keys.alarmTitle)\(i)")
            defaults.setValue(a[i].snooze, forKey: "\(Keys.alarmSnooze)\(i)")
            defaults.setValue(a[i].repeat, forKey: "\(Keys.alarmRepeat)\(i)")
            defaults.setValue(a[i].enabled, forKey: "\(Keys.alarmEnabled)\(i)")
            defaults.setValue(a[i].ringtoneId, forKey: "\(Keys.alarmRingtoneId)\(i)")
        }
        
        defaults.synchronize()
    }
}

class SettingsContainer {
    var twentyFourHour: Bool
    var snoozeInterval: Int
    var weatherZip: String
    var newsQuery: String
    var musicGenre: String
    
    convenience init(){
        self.init(twentyFourHour: false, snoozeInterval: 9, weatherZip: "49428", newsQuery: "Apple", musicGenre: "Country")
    }
    
    init(twentyFourHour: Bool, snoozeInterval: Int, weatherZip: String, newsQuery: String, musicGenre: String){
        self.twentyFourHour = twentyFourHour
        self.snoozeInterval = snoozeInterval
        self.weatherZip = weatherZip
        self.newsQuery = newsQuery
        self.musicGenre = musicGenre
    }
}

class Alarm {
    var days: [Int]
    var time: NSDate
    var title: String
    var snooze: Bool
    var repeat: Bool
    var enabled: Bool
    var ringtoneId: Int
    
    convenience init(){
        self.init(days: [0,0,0,0,0,0,0], time: NSDate(), title: "", snooze: true, repeat: true, enabled: true, ringtoneId: 1034)
    }
    
    init (days: [Int], time: NSDate, title: String, snooze: Bool, repeat: Bool, enabled: Bool, ringtoneId: Int) {
        self.days = days
        self.time = time
        self.title = title
        self.snooze = snooze
        self.repeat = repeat
        self.enabled = enabled
        self.ringtoneId = ringtoneId
    }
}

struct Keys {
    static let twentyFourHour = "twentyFourHour"
    static let snoozeInterval = "snoozeInterval"
    static let weatherZip = "weatherZip"
    static let newsQuery = "newsQuery"
    static let musicGenre = "musicGenre"
    static let alarmCount = "alarmCount"
    static let alarmDays = "alarmDays_"
    static let alarmTime = "alarmTime_"
    static let alarmTitle = "alarmTitle_"
    static let alarmSnooze = "alarmSnooze_"
    static let alarmRepeat = "alarmRepeat_"
    static let alarmEnabled = "alarmEnabled_"
    static let alarmRingtoneId = "alarmRingtoneId_"
}





