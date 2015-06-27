//
//  ShowInfoDetails.swift
//  MovileNext
//
//  Created by User on 27/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation
import TraktModels
import UIKit
import TagListView

class ShowInfoController : UIViewController {
    var show : Show!
    
    var seasons : [Season]?
    
    @IBOutlet weak var infoTextView: UITextView!
    
    let trakt = TraktHTTPClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var infoText = infoTextView.attributedText.mutableCopy() as! NSMutableAttributedString
        let noData = "No Data"
        

        var range = (infoText.string as NSString).rangeOfString("**network**")
        if let network = show?.network {
            infoText.replaceCharactersInRange(range, withString: network)
        } else {
            infoText.replaceCharactersInRange(range, withString: noData)
        }
        
        range = (infoText.string as NSString).rangeOfString("**status**")
        if let status = show?.status?.rawValue {
            infoText.replaceCharactersInRange(range, withString: status.capitalizedString)
        } else {
            infoText.replaceCharactersInRange(range, withString: noData)
        }

        range = (infoText.string as NSString).rangeOfString("**year**")
        if let year = show?.year {
            infoText.replaceCharactersInRange(range, withString: "\(year)")
        } else {
            infoText.replaceCharactersInRange(range, withString: noData)
        }

        range = (infoText.string as NSString).rangeOfString("**seasons**")
        if let seasonsNumber = seasons?.count {
            infoText.replaceCharactersInRange(range, withString: "\(seasonsNumber)")
        } else {
            infoText.replaceCharactersInRange(range, withString: noData)
        }
        
        range = (infoText.string as NSString).rangeOfString("**country**")
        if let country = show?.country {
            infoText.replaceCharactersInRange(range, withString: country.uppercaseString)
        } else {
            infoText.replaceCharactersInRange(range, withString: noData)
        }
        
        range = (infoText.string as NSString).rangeOfString("**site**")
        if let site = show?.homepageURL?.path {
            infoText.replaceCharactersInRange(range, withString: site)
        } else {
            infoText.replaceCharactersInRange(range, withString: noData)
        }
        
        infoTextView.attributedText = infoText
        infoTextView.selectable = false
    }
}
