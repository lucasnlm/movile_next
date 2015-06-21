//
//  SerieCollectionViewCell.swift
//  MovileNext
//
//  Created by User on 14/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit
import Haneke
import TraktModels

class SerieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var coverView: UIImageView!
    
    func loadShow(show: Show) {
        let placeHolder = UIImage(named: "poster")
        if let url = show.poster?.fullImageURL {
            coverView.hnk_setImageFromURL(url, placeholder: placeHolder)
        } else {
            coverView.image = placeHolder
        }
        
        titleView.text = show.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverView.hnk_cancelSetImage()
        coverView.image = nil
    }
}
