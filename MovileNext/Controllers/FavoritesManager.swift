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
            var returnValue : Set<Int>? = NSUserDefaults.standardUserDefaults().objectForKey("favorites") as? Set<Int>
            if returnValue == nil {
                returnValue = Set<Int>()
            }
            
            return returnValue!
        }
        
        set (value) {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: "favorites")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static func addFavorite(identifier: Int) {
        favorites.insert(identifier)
    }
    
    static func removeFavorite(identifier: Int) {
        favorites.remove(identifier)
    }
}