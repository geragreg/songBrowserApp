//
//  SplashScreenViewController.swift
//  Top100Songs
//
//  Created by Gergely on 18/03/16.
//  Copyright © 2016 Gergely Horvath. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Color setting for the view
        self.view.backgroundColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func startButtonTouched(sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            performSegueWithIdentifier("showApp", sender: sender)
        } else {
            let alert = UIAlertController(title: "No Internet!", message:"This app requires internet, so please make sure you are connected either to cellular or WiFi!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                
                // TODO: redirect the user to the settings page
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
        }
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
