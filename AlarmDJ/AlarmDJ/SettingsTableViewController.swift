//
//  SettingsTableViewController.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var snoozeTimeTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var twentyFourHourSwitch: UISwitch!
    @IBOutlet weak var newsQueryTextField: UITextField!
    @IBOutlet weak var musicGenreDataPicker: UIPickerView!
    
    let ldm = LocalDataManager()
    var settings = SettingsContainer()
    var genres: [String] = ["Alternative","Blues","Country","Dance","Electronic","Hip-Hop/Rap","Jazz","Klassik","Pop","Rock", "Soundtracks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        snoozeTimeTextField.delegate = self
        snoozeTimeTextField.tag = 0
        zipcodeTextField.delegate = self
        zipcodeTextField.tag = 1
        newsQueryTextField.delegate = self
        newsQueryTextField.tag = 2
        musicGenreDataPicker.dataSource = self
        musicGenreDataPicker.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        settings = ldm.loadSettings()
        
        snoozeTimeTextField.text! = "\(settings.snoozeInterval)"
        zipcodeTextField.text! = settings.weatherZip
        twentyFourHourSwitch.on = settings.twentyFourHour
        newsQueryTextField.text! = settings.newsQuery
        var index = 0
        for var i = 0; i < genres.count; i++ {
            if genres[i] == settings.musicGenre{
                index = i
            }
        }
        musicGenreDataPicker.selectRow(index, inComponent: 0, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if count(zipcodeTextField.text!) == 5 {
            settings.weatherZip = zipcodeTextField.text!
        }
        
        if count(snoozeTimeTextField.text!) > 0 {
            var timeVal: Int = (snoozeTimeTextField.text!).toInt()!
            if timeVal > 0 {
                settings.snoozeInterval = timeVal
                //ldm.saveSettings(settingsContainer: settings)
            }
        }
        
        if count (newsQueryTextField.text!) > 0 {
            settings.newsQuery = newsQueryTextField.text!
        }
        
        ldm.saveSettings(settingsContainer: settings)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func twentyFourHourSwitchClicked(sender: AnyObject) {
        settings.twentyFourHour = twentyFourHourSwitch.on
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag < 2 {
            if count(textField.text!) + count(string) <= 5 {
                return true;
            }
            return false
        } else {
            if count(textField.text!) + count(string) <= 25 {
                return true;
            }
            return false
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genres.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return genres[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        settings.musicGenre = genres[row]
    }
    
}