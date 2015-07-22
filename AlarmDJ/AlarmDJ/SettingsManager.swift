//
//  SettingsContainer.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//

import Foundation

class SettingsManager {
    
    func loadSettings() -> SettingsContainer{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var tfh: Bool
        if defaults.valueForKey(DefaultSettingsKeys.twentyFourHour) != nil {
            tfh = defaults.valueForKey(DefaultSettingsKeys.twentyFourHour) as! Bool
        } else {
            tfh = false
        }
        
        var si: Int
        if defaults.valueForKey(DefaultSettingsKeys.snoozeInterval) != nil {
            si = defaults.valueForKey(DefaultSettingsKeys.snoozeInterval) as! Int
        } else {
            si = 9
        }
        
        var wz: String
        if defaults.valueForKey(DefaultSettingsKeys.weatherZip) != nil {
            wz = defaults.valueForKey(DefaultSettingsKeys.weatherZip) as! String
        } else {
            wz = "49428"
        }
        
        return SettingsContainer(twentyFourHour: tfh, snoozeInterval: si, weatherZip: wz)
    }
    
    func saveSettings(settingsContainer sc: SettingsContainer) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(sc.twentyFourHour, forKey: DefaultSettingsKeys.twentyFourHour)
        defaults.setValue(sc.snoozeInterval, forKey: DefaultSettingsKeys.snoozeInterval)
        defaults.setValue(sc.weatherZip, forKey: DefaultSettingsKeys.weatherZip)
        
        defaults.synchronize()
    }
}

class SettingsContainer {
    var twentyFourHour: Bool
    var snoozeInterval: Int
    var weatherZip: String
    
    init(twentyFourHour: Bool, snoozeInterval: Int, weatherZip: String){
        self.twentyFourHour = twentyFourHour
        self.snoozeInterval = snoozeInterval
        self.weatherZip = weatherZip
    }
}


struct DefaultSettingsKeys {
    static let twentyFourHour = "twentyFourHour"
    static let snoozeInterval = "snoozeInterval"
    static let weatherZip = "weatherZip"
}