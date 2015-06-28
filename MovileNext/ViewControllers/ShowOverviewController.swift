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

class ShowOverviewController : UIViewController, ShowInternalViewController {
    @IBOutlet weak var showTitle: UILabel!
    
    @IBOutlet weak var showOverview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadShow(show: Show?) {
        showOverview.text = show?.overview 
    }
    
    func intrinsicContentSize() -> CGSize {
        let labelSize = 30.0 as CGFloat
        let contentSize = showOverview.contentSize.height
        
        return CGSize(width: 0, height: (labelSize + contentSize))
    }
}
