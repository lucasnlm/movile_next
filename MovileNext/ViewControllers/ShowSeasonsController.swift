//
//  ShowSeasonsController.swift
//  MovileNext
//
//  Created by User on 27/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation
import UIKit
import TraktModels

class ShowSeasonsController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var seasons : [Season]?
    
    var show : Show?
    
    let trakt = TraktHTTPClient()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == Segue.season_to_episodes {
            if let cell = sender as? SeasonTableViewCell,
                indexPath = tableview.indexPathForCell(cell) {
                    let vc = segue.destinationViewController as! EpisodesListViewController
                    vc.show = show
                    vc.season = seasons?[indexPath.row]
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = Reusable.ShowSeasonId.identifier!
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! SeasonTableViewCell
    
        let row = indexPath.row
        cell.loadSeason(seasons![row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
}