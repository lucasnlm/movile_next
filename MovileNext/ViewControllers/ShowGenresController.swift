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

class ShowGenresController : UIViewController, ShowInternalViewController {
    @IBOutlet weak var tagListView: TagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addGenresOf(show: Show?) {
        if let genres = show?.genres {
            for genre in genres {
                tagListView.addTag(genre)
            }
        }
    }
    
    func intrinsicContentSize() -> CGSize {
        let contentSize = tagListView.intrinsicContentSize().height + 70.0
        return CGSize(width: 0, height: contentSize)
    }
}
