//
//  APIService.swift
//  Tube
//
//  Created by Bryan Okafor on 9/30/16.
//  Copyright © 2016 APEX Dominion Industries. All rights reserved.
//

import UIKit

class APIService: NSObject {
    
    static let sharedInstance = APIService()
    
    let baseUrl = "http://localhost/YouTube"
    
    func fetchVideos(completion: ([Video]) -> ()) {
        fetchFeedForUrlString("\(baseUrl)/home_copy.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: ([Video]) -> ()) {
        fetchFeedForUrlString("\(baseUrl)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(completion: ([Video]) -> ()) {
        fetchFeedForUrlString("\(baseUrl)/subscription.json", completion: completion)
        
    }
    
    func fetchFeedForUrlString(urlString: String, completion: ([Video]) -> ())
    {
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            do {
                if let unwrappedData = data, jsonDictionaries = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: .MutableContainers) as? [[String: AnyObject]] {
 
        
//                    var videos = [Video]()
//                    
//                    for dictionary in jsonDictionaries {
//                        let video = Video(dictionary: dictionary)
//                        videos.append(video)
//                    }
                    
//                    let videos = jsonDictionaries.map({return Video(dictionary: $0)})
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(jsonDictionaries.map({return Video(dictionary: $0)}))
                    })
                    
                }
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(str)
            }.resume()
    }
}

//let url = NSURL(string: urlString)
//NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
//    if error != nil {
//        print(error)
//        return
//    }
//    do {
//        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
//        
//        var videos = [Video]()
//        
//        for dictionary in json as! [[String: AnyObject]] {
//            
//            //print(dictionary["title"])
//            let video = Video()
//            video.title = dictionary["title"] as? String
//            video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
//            
//            let channelDictionary = dictionary["channel"] as! [String: AnyObject]
//            let channel = Channel()
//            channel.name = channelDictionary["name"] as? String
//            channel.profileImageName = channelDictionary["profile_image_name"] as? String
//            
//            video.channel = channel
//            
//            videos.append(video)
//        }
//        dispatch_async(dispatch_get_main_queue(), {
//            completion(videos)
//        })
