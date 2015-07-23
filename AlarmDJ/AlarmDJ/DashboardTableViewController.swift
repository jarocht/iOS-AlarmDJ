//
//  DashboardTableViewController.swift
//  AlarmDJ
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 Tim Jaroch, Morgan Heyboer, Andreas Plüss (TEAM E). All rights reserved.
//
import UIKit
import Foundation

class DashboardTableViewController: UITableViewController {
    
    var news = [String]()
    // Weather cell
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var currTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
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
        
        self.getNewsGoogle("Apple", completionHandler: {
            results in
            self.news = results as! [(String)]
            self.loadNews()
        })
        
        // get zip code from settings
        var zipcode = "49401"
        self.getWeather(zipcode)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
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
            
            // variables for weather cell items
            var desc = "", image = "", city = "", currTemp = 0, minTemp = 0, maxTemp = 0
            // parsing the JSON file
            if let topLevelObj = parsedObject as? NSDictionary {
                // Get weather description
                if let weather = topLevelObj.objectForKey("weather") as? NSArray {
                    if let w = weather[0] as? NSDictionary {
                        desc = w["description"] as! String
                        image = w["icon"] as! String
                    }
                }
                // Get temperatures
                if let main = topLevelObj.objectForKey("main") as? NSDictionary {
                    currTemp = main["temp"] as! Int
                    maxTemp = main["temp_max"] as! Int
                    minTemp = main["temp_min"] as! Int
                }
                // Get city name
                city = topLevelObj["name"] as! String
            }
            self.loadWeather(desc, image: image, city: city, currTemp: currTemp, minTemp: minTemp, maxTemp: maxTemp)
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
    
}