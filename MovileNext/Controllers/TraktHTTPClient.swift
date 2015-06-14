//
//  TraktHTTPClient.swift
//  MovileNext
//
//  Created by User on 14/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation
import Alamofire

class TraktHTTPClient {
    private lazy var manager : Alamofire.Manager = {
        let configuration : NSURLSessionConfiguration = {
            var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            var headers = Alamofire.Manager.defaultHTTPHeaders
            headers["Accept-Encoding"] = "gzip"
            headers["Content-Type"] = "application/json"
            
            configuration.HTTPAdditionalHeaders = headers
            
            return configuration
        }()
        
        return Manager(configuration: configuration)
    }()
}