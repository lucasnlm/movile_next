//
//  EpisodeViewController.swift
//  MovileNext
//
//  Created by User on 13/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit
import TraktModels

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
        
        let placeHolder = UIImage(named: "bg")
        if let url = episode?.screenshot?.mediumImageURL {
            coverImageView.hnk_setImageFromURL(url, placeholder: placeHolder)
        } else {
            coverImageView.image = placeHolder
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sharedPressed(sender: UIBarButtonItem) {
        let url = NSURL(string: "www.google.com")!
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
         presentViewController(vc, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
