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
    let accountCellID = "accountCellID"
    let titles = ["Home", "Trending", "Subscription", "Account"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //We do this to remove the black screen
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        
        
        // Youtube menu bar
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            
            // decrease the gap in each cell
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = UIColor.white

        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellID)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellID)
        collectionView?.register(AccountCell.self, forCellWithReuseIdentifier: accountCellID)
        
        // Align the collection view to see all of the thumbnail
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        // page will snap in place
        collectionView?.isPagingEnabled = true
    }
    
    func setupNavBarButtons () {
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let morebutton = UIBarButtonItem(image: UIImage(named: "more_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        
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
    
    func showControllerForSetting(_ setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        dummySettingsViewController.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    func handleSearch() {
        scrollToMenuIndex(2)
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
        
//        if let titleLabel = navigationItem.titleView as? UILabel {
//            titleLabel.text = "  \(titles[Int(menuIndex)])"
//        }
        
        setTitleForIndex(menuIndex)

    }
    
    fileprivate func setTitleForIndex(_ index: Int) {
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
    fileprivate func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(230, green: 32, blue: 31)
        view.addSubview(redView)
        view.addConstraintsWithFormat("H:|[v0]|", views: redView)
        view.addConstraintsWithFormat("V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset.x)
        
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
//        if let titleLabel = navigationItem.titleView as? UILabel {
//            titleLabel.text = "  \(titles[Int(index)])"
//        }
        setTitleForIndex(Int(index))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier: String
        
        if (indexPath as NSIndexPath).item == 1 {
//            return collectionView.dequeueReusableCellWithReuseIdentifier(trendingCellID, forIndexPath: indexPath)
            identifier = trendingCellID
        } else if (indexPath as NSIndexPath).item == 2 {
//            return collectionView.dequeueReusableCellWithReuseIdentifier(subscriptionCellID, forIndexPath: indexPath)
            identifier = subscriptionCellID
            
        } else if (indexPath as NSIndexPath).item == 3 {
            
            identifier = accountCellID
        } else {
            identifier = cellID
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }

}



