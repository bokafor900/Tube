//
//  AccountFeed.swift
//  Tube
//
//  Created by Bryan Okafor on 10/28/16.
//  Copyright © 2016 APEX Dominion Industries. All rights reserved.
//

import UIKit

class AccountCell: FeedCell {

    override func fetchVideos() {
        APIService.sharedInstance.fetchAccountFeed { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

}
