//
//  FavoritesManager.swift
//  MovileNext
//
//  Created by User on 28/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation

class FavoritesManager {
    static var favorites : Set<Int> {
        get {
            var returnValue : [Int]? = NSUserDefaults.standardUserDefaults().objectForKey("favorites") as? [Int]
            if returnValue == nil {
                returnValue = Array<Int>()
            }
            
            return Set(returnValue!)
        }
        
        set (value) {
            NSUserDefaults.standardUserDefaults().setObject(Array(value), forKey: "favorites")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static func addFavorite(identifier: Int) {
        favorites.insert(identifier)
    }
    
    static func removeFavorite(identifier: Int) {
        favorites.remove(identifier)
    }
    
    static func isFavorite(indentifier: Int) -> Bool {
        return favorites.contains(indentifier)
    }
}