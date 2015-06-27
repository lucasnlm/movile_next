//
//  EpisodesListViewController.swift
//  MovileNext
//
//  Created by User on 14/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit
import TraktModels

class EpisodesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    
    let trakt = TraktHTTPClient()
    
    var season : Season?
    
    var show : Show?
    
    var episodes = [Episode]()

    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.navigationItem.title = "Season \(season!.number)"

        tableView.delegate = self
        tableView.dataSource = self
        
        if let slug = show?.identifiers.slug {
            trakt.getEpisodes(slug, season: 1) { result in
                if let value = result.value {
                    self.episodes = value
                }
                
                self.tableView.reloadData()
            }
        }
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
        cell.detailTextLabel?.text = episodes[row].title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
}
