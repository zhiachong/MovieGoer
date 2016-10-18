//
//  Story.swift
//  
//
//  Created by Zhia Chong on 10/15/16.
//
//

import Foundation
import AFNetworking

private let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
private let resourceUrl = "https://api.themoviedb.org/3/movie/now_playing"
private let photoResourceUrl = "https://image.tmdb.org/t/p/w500/"

class Story {
    class func fetchPosts(page: Int, successCallback: @escaping ([[String: AnyObject]]) -> Void, errorCallback: ((NSError?) -> Void)?) {
        let url = URL(string:resourceUrl + "?api_key=\(apiKey)&page=\(page)")
        let request = URLRequest(url: url!)
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
            if let requestError = errorOrNil {
                errorCallback?(requestError as NSError?)
            } else {
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
                        guard let results = responseDictionary["results"] as? [[String:AnyObject]] else {
                            print("Cannot get posts!")
                            return
                        }
                        
                        successCallback(results)
                    }
                }
            }
        });
        
        task.resume()
    }
    
    class func getPhotoUrl(_ photoUrl: String) -> URL {
        return URL(string: photoResourceUrl + photoUrl + "?api_key=\(apiKey)")!
    }
}
