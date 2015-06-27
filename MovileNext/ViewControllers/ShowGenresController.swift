//
//  ShowGenresView.swift
//  MovileNext
//
//  Created by User on 27/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation
import TraktModels
import UIKit
import TagListView

class ShowGenresController : UIViewController {
    var show : Show?
    
    @IBOutlet weak var tagListView: TagListView!
    
    let trakt = TraktHTTPClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let genres = show?.genres {
            for genre in genres {
                tagListView.addTag(genre)
            }
        }
    }
}
