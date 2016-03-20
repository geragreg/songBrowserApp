//
//  SongDetailViewController.swift
//  Top100Songs
//
//  Created by Gergely on 18/03/16.
//  Copyright © 2016 Gergely Horvath. All rights reserved.
//

import UIKit

class SongDetailViewController: UIViewController {

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    
    // Objects for receiving from the TableViewController
    var song : Song?
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if the received image is not nil otherwise set it to the blank placeholder
        // TODO: try to download the image again instead
        if image != nil {
            songImageView.image = image
        } else {
            songImageView.image = UIImage(named: "blank")
        }
        
        // Set the labels for the song
        titleLabel.text = "\((song?.order)!+1). "+song!.title!
        artistLabel.text = "by "+song!.artist!
        descriptionLabel.text = randomDescription(200)
        
        //Color setting for the view
        self.view.backgroundColor = UIColor.blackColor()
        titleLabel.textColor = UIColor.whiteColor()
        artistLabel.textColor = UIColor.whiteColor()
        descriptionLabel.textColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function for generating a random 200 character long description
    func randomDescription(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersCount = UInt32(characters.characters.count)
        var randomString = ""
        
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(charactersCount))
            let newCharacter = characters[characters.startIndex.advancedBy(randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
