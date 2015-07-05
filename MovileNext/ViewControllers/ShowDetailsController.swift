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

class ShowDetailsController : UIViewController, SeasonsTableViewControllerDelegate {
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
    
    var task : RetrieveImageTask?
    
    private var selectedSeason: Season!
    
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
                
                if let showId = self.show?.identifiers.trakt {
                    self.favoriteButton.selected = FavoritesManager.isFavorite(showId)
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
        
        // Basic Animation
        let favorited = sender.selected
        UIView.transitionWithView(sender, duration: 0.4, options: .TransitionCrossDissolve, animations: {sender.selected = favorited}, completion: nil)
        
        // Core Animation
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.2
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = favorited ?  1.2 : 0.8
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        sender.layer.addAnimation(pulseAnimation, forKey: nil)
        

        if let showId = show?.identifiers.trakt {
            if sender.selected {
                FavoritesManager.addFavorite(showId)
            }
            else {
                FavoritesManager.removeFavorite(showId)
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(notKey, object: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == Segue.details_to_seasons {
            seasonViewController = segue.destinationViewController as! ShowSeasonsController
            seasonViewController.seasons = seasons
            seasonViewController.show = show
            seasonViewController.delegate = self
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
        
        if segue == Segue.details_to_episodes {
            let vc = segue.destinationViewController as! EpisodesListViewController
            vc.season = selectedSeason
            vc.show = show
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        overviewConstraint.constant = overviewViewController.intrinsicContentSize().height
        seasonsConstraint.constant = seasonViewController.intrinsicContentSize().height
        genresConstraint.constant = genresViewController.intrinsicContentSize().height
    }
    
    func seasonsController(vc: ShowSeasonsController, didSelectSeason season: Season) {
        selectedSeason = season
        performSegue(Segue.details_to_episodes, sender: vc)
    }
}