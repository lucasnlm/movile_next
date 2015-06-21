//
//  JSONLoader.swift
//  exercicio
//
//  Created by User on 20/06/15.
//  Copyright (c) 2015 lucas. All rights reserved.
//

import Foundation
import Argo

class EntryParser {
    static func loadFromJson(fileName : String) -> [Entry] {
        var entriesArray : [Entry] = []
        
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json"),
        let jsonData = NSData(contentsOfFile: path),
        let jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
        
            if let responseData = jsonResult["responseData"] as? NSDictionary,
               let feed = responseData["feed"] as? NSDictionary,
               let entries = feed["entries"] as? NSArray {
                for entry in entries {
                    let temp:Entry = decode(entry)!
                    entriesArray.append(temp)
                    /*
                    var bytes = NSJSONSerialization.dataWithJSONObject(entries, options: NSJSONWritingOptions.allZeros, error: nil)
                    var jsonObj = NSJSONSerialization.JSONObjectWithData(bytes, options: nil, error: nil) as! NSDictionary
                    
                    if let j: AnyObject? = jsonObj {
                        let user: Entry? = decode(j)
                        print(user)
                    }*/
                }
            }
        }
        
        return entriesArray
    }
}
