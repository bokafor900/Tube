//
//  FeedCell.swift
//  Tube
//
//  Created by Bryan Okafor on 10/17/16.
//  Copyright © 2016 APEX Dominion Industries. All rights reserved.
//

import UIKit

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var videos: [Video]?
    
    let cellID = "Cell"
    
    func fetchVideos() {
        APIService.sharedInstance.fetchVideos { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

    override func setupViews() {
        super.setupViews()
        
        fetchVideos()
        
        backgroundColor = .blue
        
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    // implement the number of items you see in the collectionView
    func collectionView(_ collectionView:UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    // need to implement a cell for the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! VideoCell
        
        cell.video = videos?[(indexPath as NSIndexPath).item]
        
        return cell
    }
    
    // To get the size of the collection view you need UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.width - 16 - 16) * 9 / 16
        return CGSize(width: frame.width, height: height + 16 + 88)
    }
    
    // This tool is to minimize the line spacing between the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(123)
        let videoLauncher = VideoLauncher()
        videoLauncher.showVideoPlayer()
    }


}
