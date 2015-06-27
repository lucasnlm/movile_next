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

class SerieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var coverView: UIImageView!
    
    var task : RetrieveImageTask?;
    
    func loadShow(show: Show) {
        let placeHolder = UIImage(named: "poster")
        if let url = show.poster?.fullImageURL {
            task = coverView.kf_setImageWithURL(url,
                placeholderImage: placeHolder,
                optionsInfo: nil,
                progressBlock: nil,
                completionHandler: { (image, error, cacheType, imageURL) -> () in
                }
            )
        } else {
            coverView.image = placeHolder
        }
        
        titleView.text = show.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        task?.cancel()
        coverView.image = nil
    }
}
