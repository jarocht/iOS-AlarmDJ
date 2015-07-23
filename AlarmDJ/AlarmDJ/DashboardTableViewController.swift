//
//  DashboardTableViewController.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//
import UIKit
import Foundation
import EventKit

class DashboardTableViewController: UITableViewController {

    // set up local data manager for settings
    var ldm = LocalDataManager()
    // news data
    var news = [String]()
    var newsLoaded: Bool = false
    // weather data
    var desc = "", image = "", city = "", currTemp = 0, minTemp = 0, maxTemp = 0
    // calendar data
    var events = Dictionary<String, String>()
    // Weather cell
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var currTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    // Calendar Appt cell
    @IBOutlet weak var apptNameLabel: UILabel!
    @IBOutlet weak var apptDetailLabel: UILabel!
    // News cells
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var subtitleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var subtitleLabel2: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
    @IBOutlet weak var subtitleLabel3: UILabel!
    @IBOutlet weak var titleLabel4: UILabel!
    @IBOutlet weak var subtitleLabel4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        // set up settings
        var settings = ldm.loadSettings()
        // set time
        setTime(settings.twentyFourHour)
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "updateData", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        self.getNewsGoogle("Apple", completionHandler: {
            results in
            self.news = results as! [(String)]
            self.loadNews()
            self.tableView.reloadData()
        })
        
        // get zip code from settings

        var zipcode = settings.weatherZip
        self.getWeather(zipcode)
        
        // loading the calendar event
        //EventStuff
        let eventStore = EKEventStore()
        
        //Event access
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
        case .Authorized:
            println("aut")
            self.events = printTodaysEvents(eventStore)

        case .Denied:
            println("Access denied")
        case .NotDetermined:
            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
                {[weak self] (granted: Bool, error: NSError!) -> Void in
                    if granted {
                        println("granted")
                        self!.events = self!.printTodaysEvents(eventStore)
                        println(self!.events["title"])
                        println(self!.events["start"])
                    } else {
                        println("Access denied")
                    }
                })
        default:
            println("Case Default")
        }
        
        // load calendar info into view
        self.loadCalendar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var timer = NSTimer(timeInterval: 1.0, target:self, selector: "updateData", userInfo: nil,  repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.

        if segue.identifier == "news1" {
            (segue.destinationViewController as? WebViewController)?.title = self.news[0]
            (segue.destinationViewController as? WebViewController)?.webUrl = self.news[2]
        } else if segue.identifier == "news2" {
            (segue.destinationViewController as? WebViewController)?.title = self.news[3]
            (segue.destinationViewController as? WebViewController)?.webUrl = self.news[5]
        } else if segue.identifier == "news3" {
            (segue.destinationViewController as? WebViewController)?.title = self.news[6]
            (segue.destinationViewController as? WebViewController)?.webUrl = self.news[8]
        } else if segue.identifier == "news4" {
            (segue.destinationViewController as? WebViewController)?.title = self.news[9]
            (segue.destinationViewController as? WebViewController)?.webUrl = self.news[11]
        } else if segue.identifier == "newsMore" {
            (segue.destinationViewController as? WebViewController)?.title = "More news"
            (segue.destinationViewController as? WebViewController)?.webUrl = "https://www.google.com/search?q=" + "Apple" + "&tbm=nws&cad=h"
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return self.newsLoaded
    }
    
    // Function used in the refresh control to update all of the data
    func updateData() {
        var settings = self.ldm.loadSettings()
        // update weather data
        self.loadWeather(self.desc, image: self.image, city: self.city, currTemp: self.currTemp, minTemp: self.minTemp, maxTemp: self.maxTemp)
        
        // update news data
        self.loadNews()
//        self.titleLabel1!.text = self.news[0]
//        self.subtitleLabel1!.text = self.news[1]
//        self.titleLabel2!.text = self.news[3]
//        self.subtitleLabel2!.text = self.news[4]
//        self.titleLabel3!.text = self.news[6]
//        self.subtitleLabel3!.text = self.news[7]
//        self.titleLabel4!.text = self.news[9]
//        self.subtitleLabel4!.text = self.news[10]
        
        // update calendar data
        self.loadCalendar()
        
        self.setTime(settings.twentyFourHour)

        //self.tableView.reloadData()
        //self.refreshControl?.endRefreshing()

    }
    
    /* Gives back an array of Title and Links to
    * the website through a callback function
    */
    func getNewsGoogle(query:String, completionHandler: (results: NSArray) -> ()){
        //TODO: get genericly the clients IP-Address
        //http://stackoverflow.com/questions/28084853/how-to-get-the-local-host-ip-address-on-iphone-in-swift
        
        var resultsArray = [String]()
        
        //var ipAddressGuestNetwork:String = "35.40.153.91"
        var ipAddress:String = "148.61.162.228"
        
        //creating query
        var queryParams:String = "&q=" + query + "&userip="+ipAddress
        let baseUrl = NSURL(string: "https://ajax.googleapis.com/ajax/services/search/news")!
        let url = NSURL(string: "?v=1.0" + queryParams, relativeToURL:baseUrl)!
        
        //creat session
        let session = NSURLSession.sharedSession()
        var parseError : NSError?
        
        //receive data and put it into return array
        let task = session.downloadTaskWithURL(url) {
            (loc:NSURL!, response:NSURLResponse!, error:NSError!) in
            let d = NSData(contentsOfURL: loc)!
            let parsedObject: AnyObject?  =
            NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
            if let json = parsedObject as? NSDictionary {
                if let responseData = json.objectForKey("responseData") as? NSDictionary {
                    if let results = responseData.objectForKey("results") as? NSArray {
                        for entry in results {
                            let title = entry.objectForKey("title") as? String
                            resultsArray.append(self.htmlDecode(title!))
                            
                            let content = entry.objectForKey("content") as? String
                            resultsArray.append(self.htmlDecode(content!))
                            
                            let newsUrl = entry.objectForKey("url") as? String
                            resultsArray.append(newsUrl!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                        }
                    }
                    if let cursor = responseData.objectForKey("cursor") as? NSDictionary {
                        let moreResults = cursor.objectForKey("moreResultsUrl") as? String
                        let moreResultsURL = NSURL(fileURLWithPath: moreResults!)
                        resultsArray.append(moreResults!)
                    }
                }
            }
            completionHandler(results: resultsArray)
            self.news = resultsArray as [String]
            self.newsLoaded = true
        }
        task.resume()
    }
    
    /* Description:
    * function provided by
    * http://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift
    */
    func htmlDecode(encodedString:String) -> String {
        let encodedData = encodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)!
        let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’
        
        return decodedString
    }
    
    func loadNews() {
        self.titleLabel1!.text = self.news[0]
        self.subtitleLabel1!.text = self.news[1]
        self.titleLabel2!.text = self.news[3]
        self.subtitleLabel2!.text = self.news[4]
        self.titleLabel3!.text = self.news[6]
        self.subtitleLabel3!.text = self.news[7]
        self.titleLabel4!.text = self.news[9]
        self.subtitleLabel4!.text = self.news[10]
    }
    
    func getWeather(zip: String) -> () {
        let weatherUrl = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?zip=\(zip),us&units=imperial")
        let session = NSURLSession.sharedSession()
        var parseError : NSError?
        
        let task = session.downloadTaskWithURL(weatherUrl!) {
            (loc: NSURL!, response: NSURLResponse!, error: NSError!) in
            let data = NSData(contentsOfURL: loc)!
            let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
            
            // parsing the JSON file
            if let topLevelObj = parsedObject as? NSDictionary {
                // Get weather description
                if let weather = topLevelObj.objectForKey("weather") as? NSArray {
                    if let w = weather[0] as? NSDictionary {
                        self.desc = w["description"] as! String
                        self.image = w["icon"] as! String
                    }
                }
                // Get temperatures
                if let main = topLevelObj.objectForKey("main") as? NSDictionary {
                    self.currTemp = main["temp"] as! Int
                    self.maxTemp = main["temp_max"] as! Int
                    self.minTemp = main["temp_min"] as! Int
                }
                // Get city name
                self.city = topLevelObj["name"] as! String
            }
            self.loadWeather(self.desc, image: self.image, city: self.city, currTemp: self.currTemp, minTemp: self.minTemp, maxTemp: self.maxTemp)
        }
        task.resume()


    }
    
    func loadWeather(weatherDesc: String, image: String, city: String, currTemp: Int, minTemp: Int, maxTemp: Int) {
        self.weatherDescLabel!.text = weatherDesc
        self.cityLabel!.text = city
        self.currTempLabel!.text = "\(currTemp)"
        self.minTempLabel!.text = "Low: \(minTemp)"
        self.maxTempLabel!.text = "High: \(maxTemp)"
        self.imageView?.image = UIImage(named: image)
    }
    
    /* Requires an EKEventStore() Object
    * Returns a Dictionary with the title and start DateTime of the
    * first event of the day
    */
    func printTodaysEvents(store: EKEventStore) -> Dictionary<String, String> {
        var result = Dictionary<String, String>()
        let cals = store.calendarsForEntityType(EKEntityTypeEvent)

        let today = NSDate()
        
        //yesterday
        let delta = NSDate()
        let tomorrow = delta.dateByAddingTimeInterval(60*60*24)
        
        println(today)
        println(tomorrow)
        
        let fetchCalendarEvent =
        store.predicateForEventsWithStartDate(today, endDate: tomorrow, calendars:
            cals)
        
        if let eventlist = store.eventsMatchingPredicate(fetchCalendarEvent) {
            var event = eventlist[0] as! EKEvent
            let title = event.title!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a" // superset of OP's format
            let start = dateFormatter.stringFromDate(event.startDate)
            result = ["title": title, "start": start]
        } else {
            result = ["title": "There are no Events", "start": ""]
        }
        return result
    }
    
    func loadCalendar() {
        self.apptNameLabel!.text = events["title"]
        self.apptDetailLabel!.text = events["start"]
    }
    
    func setTime(format24: Bool) {
        var time: NSDate = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "EDT")
        if format24 {
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm")
        }
        self.timeLabel!.text = dateFormatter.stringFromDate(time)
    }
}