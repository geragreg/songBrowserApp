//
//  SongTableViewCell.swift
//  Top100Songs
//
//  Created by Gergely on 17/03/16.
//  Copyright © 2016 Gergely Horvath. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var song: Song! {
        didSet {
            artistLabel.text = "/(song.order+1). "+song.artist!
            titleLabel.text = song.title
            songImageView.image = UIImage(named: "random")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
