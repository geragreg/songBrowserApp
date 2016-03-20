//
//  Song.swift
//  Top100Songs
//
//  Created by Gergely on 15/03/16.
//  Copyright © 2016 Gergely Horvath. All rights reserved.
//

import Foundation

struct Song {
    var order: Int?
    var title: String?
    var artist: String?
    var iTunesUrl: String?
    var imageUrl: String?
    
    init(order: Int?, title: String?, artist: String?, iTunesUrl: String?, imageUrl: String?) {
        self.order = order
        self.title = title
        self.artist = artist
        self.iTunesUrl = iTunesUrl
        self.imageUrl = imageUrl
    }
}
