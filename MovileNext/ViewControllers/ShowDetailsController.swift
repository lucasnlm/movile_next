//
//  ShowDetails.swift
//  MovileNext
//
//  Created by User on 27/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation
import UIKit
import TraktModels

class ShowDetailsController : UIViewController {
    var show : Show?
    
    var seasons = [Season]()
    
    let trakt = TraktHTTPClient()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let slug = show?.identifiers.slug {
            trakt.getSeasons(slug) { result in
                if let value = result.value {
                    self.seasons = value
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == Segue.details_to_seasons {
            let vc = segue.destinationViewController as! ShowSeasonsController
            vc.seasons = seasons
            vc.show = show
        }
        if segue == Segue.details_to_overview {
            let vc = segue.destinationViewController as! ShowOverviewController
            vc.show = show
        }
        if segue == Segue.details_to_genres {
            let vc = segue.destinationViewController as! ShowGenresController
            vc.show = show
        }
        if segue == Segue.details_to_info {
            let vc = segue.destinationViewController as! ShowInfoController
            vc.seasons = seasons
            vc.show = show
        }
    }
}