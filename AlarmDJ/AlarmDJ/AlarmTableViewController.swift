//
//  ViewController.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var settings = LocalDataManager().loadSettings()
        
        println(settings.weatherZip)
        
        settings.weatherZip = "49426"
        
        LocalDataManager().saveSettings(settingsContainer: settings)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return
    }*/
    
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    }*/
}