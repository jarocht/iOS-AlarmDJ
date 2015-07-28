//
//  AlarmAlertViewController.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//

import UIKit
import EventKit
import AudioToolbox

class AlarmAlertViewController: UIViewController{
    
    let ldm = LocalDataManager()
    var alarm = Alarm()
    
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var settings = ldm.loadSettings()
        self.setTime()
    }
    
    override func viewDidAppear(animated: Bool) {
        var toneIdSound = UInt32(alarm.ringtoneId)
        // only rings if system sounds are avaible
        // this is the case when the app is run on a
        // arm architecture
        #if (arch(i386) || arch(x86_64)) && os(iOS)
        #else
        AudioServicesPlaySystemSound(toneIdSound)
        #endif
        super.viewDidAppear(animated)
        
        var timer = NSTimer(timeInterval: 1.0, target:self, selector: "setTime", userInfo: nil,  repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func dismissPressed(sender: UIButton) {
        
    }
    
    func setTime() {
        var settings = ldm.loadSettings()
        var time: NSDate = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "EDT")
        if settings.twentyFourHour {
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm")
        }
        self.timeLabel!.text = dateFormatter.stringFromDate(time)
    }
    
}
