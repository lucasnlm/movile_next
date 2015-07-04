//
//  EpisodeViewController.swift
//  MovileNext
//
//  Created by User on 13/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit
import TraktModels
import Kingfisher

extension UIImage {
    func darkenImage() -> UIImage {
        let context = CIContext()
        let input = CoreImage.CIImage(image: self)
        
        let filter = CIFilter(name: "CIExposureAdjust")
        filter.setValue(input, forKey: "inputImage")
        filter.setValue(-2, forKey: "inputEV")
        
        let output = UIImage(CIImage: filter.outputImage)
        return output!
    }
}

class EpisodeViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var episodeNameView: UILabel!
    
    @IBOutlet weak var episodeDescriptionView: UITextView!
    
    @IBOutlet weak var overviewText: UILabel!
    
    var show : Show?
    
    var episode : Episode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodeDescriptionView.textContainer.lineFragmentPadding = 0
        episodeDescriptionView.textContainerInset = UIEdgeInsetsZero
        
        loadEpisode()
    }

    func loadEpisode() {
        self.navigationItem.title = show?.title
        
        episodeNameView.text = episode?.title
        episodeDescriptionView.text = episode?.overview
        
        let placeHolder = UIImage(named: "bg")?.darkenImage()
        if let url = episode?.screenshot?.mediumImageURL {
            coverImageView.kf_setImageWithURL(url,
                placeholderImage: placeHolder,
                optionsInfo: nil,
                progressBlock: nil,
                completionHandler: { (image, error, cacheType, imageURL) -> () in
                    image?.darkenImage()
                }
            )
        } else {
            coverImageView.image = placeHolder
        }
    }

    @IBAction func sharedPressed(sender: UIBarButtonItem) {
        if let imdb = show?.identifiers.imdb {
            let serieImdb = "http://www.imdb.com/title/\(imdb)/"
        
            let url = NSURL(string: serieImdb)!
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
            presentViewController(vc, animated: true, completion: nil)
        }
    }
}
