//
//  TrendingCell.swift
//  Tube
//
//  Created by Bryan Okafor on 10/18/16.
//  Copyright © 2016 APEX Dominion Industries. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {

    override func fetchVideos() {
        APIService.sharedInstance.fetchTrendingFeed { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

}
