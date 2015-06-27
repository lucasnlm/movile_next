//
//  SerieCollectionViewCell.swift
//  MovileNext
//
//  Created by User on 14/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit
import Kingfisher
import TraktModels
import FloatRatingView

class SeasonTableViewCell: UITableViewCell {
    
    var task : RetrieveImageTask?;
    
    @IBOutlet weak var seasonTitle: UILabel!
    
    @IBOutlet weak var seasonEpisodes: UILabel!
    
    @IBOutlet weak var seasonCover: UIImageView!
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    @IBOutlet weak var ratingTextView: UILabel!
    
    func loadSeason(season: Season) {
        let placeHolder = UIImage(named: "poster")
        if let url = season.poster?.fullImageURL {
            task = seasonCover.kf_setImageWithURL(url,
                placeholderImage: placeHolder,
                optionsInfo: nil,
                progressBlock: nil,
                completionHandler: { (image, error, cacheType, imageURL) -> () in
                }
            )
        } else {
            seasonCover.image = placeHolder
        }
        
        seasonTitle.text = "Season \(season.number)"
        
        if season.airedEpisodes == 0 {
            seasonEpisodes.text = "no episodes"
        }
        else if season.airedEpisodes == 1 {
            seasonEpisodes.text = "1 episode"
        } else {
            seasonEpisodes.text = "\(season.airedEpisodes!) episodes"
        }
        
        floatRatingView.rating = season.rating!
        ratingTextView.text = "\(season.rating!)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        task?.cancel()
        let placeHolder = UIImage(named: "poster")
        seasonCover.image = placeHolder
    }
}
