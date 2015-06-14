//
//  EpisodeTableViewCell.swift
//  MovileNext
//
//  Created by User on 14/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel?.textColor = UIColor.blackColor()
        textLabel?.font = UIFont.systemFontOfSize(15)
        
        detailTextLabel?.textColor = UIColor.mup_textColor()
        detailTextLabel?.font = UIFont.systemFontOfSize(18)
    }
}
