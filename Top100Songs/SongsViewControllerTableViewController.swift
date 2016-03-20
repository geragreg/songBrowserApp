//
//  SongsViewControllerTableViewController.swift
//  Top100Songs
//
//  Created by Gergely on 15/03/16.
//  Copyright © 2016 Gergely Horvath. All rights reserved.
//

import UIKit

class SongsViewControllerTableViewController: UITableViewController {
    
    // TODO: implement a country picker, so the user can get the top 100 songs for more countries
    
    // Hardcoded URL for getting the top 100 songs according to iTunes
    let TopSongsURL = "https://itunes.apple.com/fi/rss/topsongs/limit=100/json"
    // Dictionary for caching the downloaded images, to avoid multiple download of an image
    var imageCache = [String:UIImage]()
    // Array of dictionaries
    var songObjectDict = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding a refresh mechanism to the app
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Checking if the device is connected to a network
        if Reachability.isConnectedToNetwork() == true {
            jsonParser(TopSongsURL)
        } else {
            let alert = UIAlertController(title: "No Internet!", message:"This app requires internet, so please make sure you are connected either to cellular or WiFi!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                
                // TODO: redirect the user to the settings page/start page and block content
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
        }
        
        //Color setting for the view
        self.view.backgroundColor = UIColor.blackColor()
        
        self.navigationItem.leftBarButtonItem = nil
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Refreshing the tableView after a pulling down motion
    func refresh(sender:AnyObject)
    {
        // Check if the device is connected to the network
        // If yes, lets try to download and parse the source data for the app
        if Reachability.isConnectedToNetwork() == true {
            jsonParser(TopSongsURL)
        // If not, alert the user 
            //TODO: navigate to settings to help the user connect to a network
        } else {
            let alert = UIAlertController(title: "No Internet!", message:"This app requires internet, so please make sure you are connected either to cellular or WiFi!", preferredStyle: .Alert)
            
            // TODO: clear this shit
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
            self.refreshControl?.endRefreshing()
        }
    }
    
    // Error types for the JSON parsing
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    // JSON downloader and parser function
    func jsonParser(url:String){
        
        let urlPath = url
        let endpoint = NSURL(string: urlPath)
        let request = NSMutableURLRequest(URL:endpoint!)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                guard let dat = data else { throw JSONError.NoData }
                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
                
                if let feed = json["feed"] as? [String:AnyObject] {
                    if let entries = feed["entry"] as? [[String:AnyObject]] {
                        var songDictionary = [String:AnyObject]()
                        for entry in entries {
                            if let im_name = entry["im:name"] as? [String:AnyObject] {
                                if let title = im_name["label"] as? String {
                                    songDictionary["title"] = title
                                }
                            }
                            if let id = entry["id"] as? [String:AnyObject] {
                                if let url = id["label"] as? String {
                                    songDictionary["url"] = url
                                }
                            }
                            if let im_artist = entry["im:artist"] as? [String:AnyObject] {
                                if let artist = im_artist["label"] as? String {
                                    songDictionary["artist"] = artist
                                }
                            }
                            // Choosing the biggest resolution image -> im_image[2], as 0 and 1 are smaller
                            if let im_image = entry["im:image"] as? [[String:AnyObject]] {
                                if let image = im_image[2]["label"] as? String {
                                    songDictionary["image_url"] = image
                                }
                            }
                            
                            // Create the Song object and add the parsed song to the array of songs
                            let currentSong = Song(
                                order: self.songObjectDict.count,
                                title: songDictionary["title"] as? String,
                                artist: songDictionary["artist"] as? String,
                                iTunesUrl: songDictionary["url"] as? String,
                                imageUrl: songDictionary["image_url"] as? String)
                            
                            self.songObjectDict.append(currentSong)
                            self.refreshTable()
                            self.refreshControl?.endRefreshing()
                        }
                    }
                }
            } catch let error as JSONError {
                print(error.rawValue)
            } catch {
                print(error)
            }
            }.resume()
    }
    
    // Refresh the content of the table
    func refreshTable()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    // Download on a background thread the image for a song based on its URL
    func imageForSong(url: String) {
        let urlPath = url
        let endpoint = NSURL(string: urlPath)
        let request = NSMutableURLRequest(URL:endpoint!)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            // Convert the downloaded data in to a UIImage object
            let image = UIImage(data: data!)
            
            // Store the image in to our cache
            self.imageCache[url] = image
            self.tableView.reloadData()
            }.resume()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songObjectDict.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomSongCell", forIndexPath: indexPath) as? SongTableViewCell
        
        if Reachability.isConnectedToNetwork() == true {
            
            // Find the current song from the array of songs
            let currentSong = self.songObjectDict[indexPath.row]
            
            // Make sure the image fits into the size of the ImageView
            cell!.songImageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            // Check if the image for the song is already downloaded
            if let img = self.imageCache[currentSong.imageUrl!] {
                cell!.songImageView!.image = img
            // Only download it if it has not been downloaded yet
            } else {
                imageForSong(currentSong.imageUrl!)
            }
            
            // Set the labels for the cell
            cell?.artistLabel.text = "by "+currentSong.artist!
            cell?.titleLabel.text = "\(indexPath.row+1). "+currentSong.title!
        } else {
            // TODO: make sure the app does not get to this point
            //       if there is no internet the app should be redirected to the start page
            cell?.songImageView!.image = UIImage(named: "blank")
        }
        
        //Color settings for the cell
        cell!.backgroundColor = UIColor.blackColor()
        cell?.artistLabel.textColor = UIColor.whiteColor()
        cell?.titleLabel.textColor = UIColor.whiteColor()

        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            if segue.identifier == "showDetail" {
                let songDetailViewController = segue.destinationViewController as! SongDetailViewController
                
                // Find the selected cell and send its content to the DetailViewController
                if let selectedSongCell = sender as? SongTableViewCell {
                    let indexPath = tableView.indexPathForCell(selectedSongCell)!
                    let selectedSong = songObjectDict[indexPath.row]
                    
                    songDetailViewController.song = selectedSong
                    
                    //If we have the image already downloaded pass it as well
                    if let img = self.imageCache[selectedSong.imageUrl!] {
                        songDetailViewController.image = img
                    }
                }
            }

        
    }

}
