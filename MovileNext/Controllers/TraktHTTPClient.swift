//
//  TraktHTTPClient.swift
//  MovileNext
//
//  Created by User on 14/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation
import Alamofire
import Result
import TraktModels
import Argo

class TraktHTTPClient {
    private lazy var manager : Alamofire.Manager = {
        let configuration : NSURLSessionConfiguration = {
            var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            var headers = Alamofire.Manager.defaultHTTPHeaders
            headers["Accept-Encoding"] = "gzip"
            headers["Content-Type"] = "application/json"
            headers["trakt-api-key"] = "1737ff9a86ab7e843fe8493bbf212eba45d2c74b890e9f2629657cc29bd9e425"
            headers["trakt-api-version"] = "2"
            
            configuration.HTTPAdditionalHeaders = headers
            
            return configuration
        }()
        
        return Manager(configuration: configuration)
    }()
    
    func getPopularShows(completion: ((Result<[Show], NSError?>) -> Void)?) {
        getJSONElement(Router.PopularShows(), completion: completion)
    }
    
    func getShow(id: String, completion: ((Result<Show, NSError?>) -> Void)?) {
        getJSONElement(Router.Show(id), completion: completion)
    }
    
    func getEpisodes(show: String, season: Int, completion: ((Result<[Episode], NSError?>) -> Void)?) {
        getJSONElement(Router.Episodes(show, season), completion: completion)
    }
    
    func getEpisode(show: String, season: Int, episode: Int, completion: ((Result<Episode, NSError?>) -> Void)?) {
        getJSONElement(Router.Episode(show, season, episode), completion: completion)
    }
    
    func getSeasons(show: String, completion: ((Result<[Season], NSError?>) -> Void)?) {
        getJSONElement(Router.Seasons(show), completion: completion)
    }
    
    private func getJSONElement<T: Decodable where T.DecodedType == T>(router: Router, completion: ((Result<T, NSError?>) -> Void)?) {
        manager.request(router).validate().responseJSON{ (_, _, responseObject, error) in
            if let json = responseObject as? NSDictionary {
                let decoded = T.decode(JSON.parse(json))
                
                if let value = decoded.value {
                    completion?(Result.success(value))
                } else {
                    completion?(Result.failure(nil))
                }
            } else {
                completion?(Result.failure(error))
            }
        }
    }
    
    private func getJSONElement<T: Decodable where T.DecodedType == T>(router: Router, completion: ((Result<[T], NSError?>) -> Void)?) {
        manager.request(router).validate().responseJSON{ (_, _, responseObject, error) in
            if let json = responseObject as? [NSDictionary] {
                var elements = [T]()
                
                for element in json {
                    let decoded = T.decode(JSON.parse(element))

                    if let value = decoded.value {
                        elements.append(value)
                    }
                }
                
                completion?(Result.success(elements))
            } else {
                completion?(Result.failure(error))
            }
        }
    }

}

private enum Router : URLRequestConvertible {
    static let baseURLString = "https://api-v2launch.trakt.tv/"
    
    case Show(String)
    case Episode(String, Int, Int)
    case PopularShows()
    case Episodes(String, Int)
    case Seasons(String)
    
    // MARK: URLRequestConvertible
    var URLRequest: NSURLRequest {
        let (path: String, parameters: [String: AnyObject]?, method: Alamofire.Method) = {
            
            switch self {
                case .Show(let id):
                    return ("shows/\(id)", ["extended": "images,full"], .GET)
                case .Episode(let id, let season, let episode):
                    return ("shows/\(id)/seasons/\(season)/episodes/\(episode)", ["extended": "images,full"], .GET)
                case .PopularShows():
                    return ("shows/popular", ["extended": "images", "limit" : "30"], .GET)
                case .Episodes(let id, let season):
                    return ("shows/\(id)/seasons/\(season)", ["extended": "images,full"], .GET)
                case .Seasons(let id):
                    return ("shows/\(id)/seasons", ["extended": "images,full"], .GET)
            }
        
        }()
    
        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        URLRequest.HTTPMethod = method.rawValue
        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(URLRequest, parameters: parameters).0
    }
}
