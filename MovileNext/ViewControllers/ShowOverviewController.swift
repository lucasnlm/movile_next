//
//  ShowOverviewController.swift
//  MovileNext
//
//  Created by User on 27/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation
import TraktModels
import UIKit

class ShowOverviewController : UIViewController {    
    var show : Show?
    
    let trakt = TraktHTTPClient()
    
    @IBOutlet weak var showTitle: UILabel!
    
    @IBOutlet weak var showOverview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTitle.text = show?.title

        if let slug = show?.identifiers.slug {
            trakt.getShow(slug) { result in
                self.showOverview.text = result.value?.overview
            }
        }
    }
}
