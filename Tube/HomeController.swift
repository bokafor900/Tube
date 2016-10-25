//
//  ViewController.swift
//  Tube
//
//  Created by Bryan Okafor on 9/6/16.
//  Copyright © 2016 APEX Dominion Industries. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "Cell"
    let trendingCellID = "trendingCellID"
    let subscriptionCellID = "subscriptionCellID"
    let titles = ["Home", "Trending", "Subscription", "Account"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //We do this to remove the black screen
        navigationController?.navigationBar.translucent = false
        
        let titleLabel = UILabel(frame: CGRectMake(0,0, view.frame.width - 32, view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(20)
        navigationItem.titleView = titleLabel
        
        
        
        // Youtube menu bar
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .Horizontal
            
            // decrease the gap in each cell
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = UIColor.whiteColor()

        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.registerClass(TrendingCell.self, forCellWithReuseIdentifier: trendingCellID)
        collectionView?.registerClass(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellID)
        
        // Align the collection view to see all of the thumbnail
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        // page will snap in place
        collectionView?.pagingEnabled = true
    }
    
    func setupNavBarButtons () {
        let searchImage = UIImage(named: "search")?.imageWithRenderingMode(.AlwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .Plain, target: self, action: #selector(handleSearch))
        
        let morebutton = UIBarButtonItem(image: UIImage(named: "more_icon")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [morebutton, searchBarButtonItem]
    }
    
//    let blackView = UIView()
    lazy var settingsLaucher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    // Show Settings Menu
    func handleMore() {
        settingsLaucher.showSettings()
        
    }
    
    func showControllerForSetting(setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        dummySettingsViewController.view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    func handleSearch() {
        scrollToMenuIndex(2)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(forItem: menuIndex, inSection: 0)
        collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
        
//        if let titleLabel = navigationItem.titleView as? UILabel {
//            titleLabel.text = "  \(titles[Int(menuIndex)])"
//        }
        
        setTitleForIndex(menuIndex)

    }
    
    private func setTitleForIndex(index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[Int(index)])"
        }
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    // Setup Menu bar function
    private func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(230, green: 32, blue: 31)
        view.addSubview(redView)
        view.addConstraintsWithFormat("H:|[v0]|", views: redView)
        view.addConstraintsWithFormat("V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //print(scrollView.contentOffset.x)
        
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.memory.x / view.frame.width
        
        let indexPath = NSIndexPath(forItem: Int(index), inSection: 0)
        menuBar.collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
        
//        if let titleLabel = navigationItem.titleView as? UILabel {
//            titleLabel.text = "  \(titles[Int(index)])"
//        }
        setTitleForIndex(Int(index))
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier: String
        
        if indexPath.item == 1 {
//            return collectionView.dequeueReusableCellWithReuseIdentifier(trendingCellID, forIndexPath: indexPath)
            identifier = trendingCellID
        } else if indexPath.item == 2 {
//            return collectionView.dequeueReusableCellWithReuseIdentifier(subscriptionCellID, forIndexPath: indexPath)
            identifier = subscriptionCellID
        } else {
            identifier = cellID
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, view.frame.height - 50)
    }

}



