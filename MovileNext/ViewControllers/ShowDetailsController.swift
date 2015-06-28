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
import Kingfisher
import FloatRatingView

class ShowDetailsController : UIViewController {
    var show : Show?
    
    private weak var overviewViewController : ShowOverviewController!
    
    private weak var seasonViewController : ShowSeasonsController!
    
    private weak var genresViewController : ShowGenresController!
    
    private weak var infoViewController : ShowInfoController!
    
    @IBOutlet weak var overviewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var seasonsConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var genresConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var showRatingView: FloatRatingView!
    
    @IBOutlet weak var showRatingTextView: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var seasons = [Season]()
    
    let trakt = TraktHTTPClient()
    
    @IBOutlet weak var showPoster: UIImageView!
    
    @IBOutlet weak var tableview: UITableView!
    
    var task : RetrieveImageTask?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let slug = show?.identifiers.slug {
            trakt.getShow(slug) { result in
                self.show = result.value
                self.overviewViewController.loadShow(self.show)
                self.genresViewController.addGenresOf(self.show)

                var formatter = NSNumberFormatter()
                formatter.decimalSeparator = ","
                formatter.maximumFractionDigits = 1
                formatter.maximumIntegerDigits = 2
                self.showRatingTextView.text = formatter.stringFromNumber(self.show!.rating!)
                self.showRatingView.rating = self.show!.rating!
                
                self.trakt.getSeasons(slug) { result in
                    if let value = result.value {
                        self.seasons = value
                        self.seasonViewController.loadSeasons(value)
                        self.infoViewController.loadShow(self.show, seasons: value)
                    }
                }
            }
        }
        
        self.navigationItem.title = show?.title
        
        let placeHolder = UIImage(named: "poster")
        if let url = show?.thumbImageURL {
            task = showPoster.kf_setImageWithURL(url,
                placeholderImage: placeHolder,
                optionsInfo: nil,
                progressBlock: nil,
                completionHandler: { (image, error, cacheType, imageURL) -> () in
                }
            )
        } else {
            showPoster.image = placeHolder
        }
    }
    
    @IBAction func favoritePressed(sender: UIButton) {
        sender.selected = !sender.selected
        
        if sender.selected {
            FavoritesManager.addFavorite(show?.identifiers.trakt)
        }
        else {
            FavoritesManager.removeFavorite(show?.identifiers.trakt)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == Segue.details_to_seasons {
            seasonViewController = segue.destinationViewController as! ShowSeasonsController
            seasonViewController.seasons = seasons
            seasonViewController.show = show
        }
        
        if segue == Segue.details_to_overview {
            overviewViewController = segue.destinationViewController as! ShowOverviewController
        }
        
        if segue == Segue.details_to_genres {
            genresViewController = segue.destinationViewController as! ShowGenresController
        }
        
        if segue == Segue.details_to_info {
            infoViewController = segue.destinationViewController as! ShowInfoController
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        overviewConstraint.constant = overviewViewController.intrinsicContentSize().height
        seasonsConstraint.constant = seasonViewController.intrinsicContentSize().height
        genresConstraint.constant = genresViewController.intrinsicContentSize().height
    }
}