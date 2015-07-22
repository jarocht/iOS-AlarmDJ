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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.getNewsGoogle("Apple", completionHandler: {
            results in
            println("data: \(results)")
            self.news = results as! [(String)]
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 6
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell", forIndexPath: indexPath) as! NewsTableViewCell
        
        let title = news[(indexPath.row * 3)+1]
        let subtitle = news[(indexPath.row * 3)+2]
        let link = news[(indexPath.row * 3)+3]
        
        cell.headlineLabel!.text = title
        cell.descLabel!.text = subtitle

        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
    
//    func readWeather(url: String) -> () {
//        
//    }
    
}