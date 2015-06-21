//
//  EntryTableViewCell.swift
//  exercicio
//
//  Created by User on 20/06/15.
//  Copyright (c) 2015 lucas. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

       // textLabel?.font = UIFont.systemFontOfSize(15)
    }
}