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
    
    func fetchVideos(_ completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString("\(baseUrl)/home_copy.json", completion: completion)
    }
    
    func fetchTrendingFeed(_ completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString("\(baseUrl)/trending.json", completion: completion)
    }
    
    func fetchSubscriptionFeed(_ completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString("\(baseUrl)/subscription.json", completion: completion)
        
    }
    
    func fetchAccountFeed(_ completion: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString("\(baseUrl)/account.json", completion: completion)
        
    }
    
    func fetchFeedForUrlString(_ urlString: String, completion: @escaping ([Video]) -> ())
    {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            do {
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: AnyObject]] {
                    
                    DispatchQueue.main.async(execute: {
                        completion(jsonDictionaries.map({return Video(dictionary: $0)}))
                    })
                    
                }
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(str)
            }) .resume()
    }
}


