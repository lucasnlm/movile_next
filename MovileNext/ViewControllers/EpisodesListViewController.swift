//
//  EpisodesListViewController.swift
//  MovileNext
//
//  Created by User on 14/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit
import TraktModels

class EpisodesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SeasonsTableViewControllerDelegate  {

    @IBOutlet weak var tableView: UITableView!
    
    let trakt = TraktHTTPClient()
    
    var season : Season?
    
    var show : Show?
    
    var episodes = [Episode]()

    override func viewDidLoad() {
        super.viewDidLoad()
 
        if let seasonNumber = season?.number {
            if seasonNumber != 0 {
                self.navigationItem.title = "Season \(seasonNumber)"
            } else {
                self.navigationItem.title = "Specials"
            }
            
            if let slug = show?.identifiers.slug {
                trakt.getEpisodes(slug, season: seasonNumber) { result in
                    if let value = result.value {
                        self.episodes = value
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func seasonsController(vc: ShowSeasonsController, didSelectSeason season: Season) {
        self.season = season
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == Segue.show_to_show {
            if let cell = sender as? UITableViewCell,
                indexPath = tableView.indexPathForCell(cell) {
                    let vc = segue.destinationViewController as! EpisodeViewController
                    vc.episode = episodes[indexPath.row]
                    vc.show = show
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = Reusable.EpisodeCell.identifier!
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = String(format: "S%02dE%02d", season!.number, indexPath.row + 1)
        
        
        if let title = episodes[row].title {
            if title.isEmpty || title == "TBA" {
                cell.detailTextLabel?.text = "to be announced"
            } else {
                cell.detailTextLabel?.text = title
            }
        } else {
            cell.detailTextLabel?.text = "to be announced"            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}
