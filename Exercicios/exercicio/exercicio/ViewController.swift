//
//  ViewController.swift
//  exercicio
//
//  Created by User on 20/06/15.
//  Copyright (c) 2015 lucas. All rights reserved.
//

import UIKit
import Argo

class ViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var entryTableView: UITableView!
    
    var entries : [Entry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Entry List"
        
        entryTableView.delegate = self
        entryTableView.dataSource = self
        
        
        entryTableView.estimatedRowHeight = 68.0
        entryTableView.rowHeight = UITableViewAutomaticDimension
        
        entries = EntryParser.loadFromJson("new-pods")
    }
    
    override func viewDidAppear(animated: Bool) {
        entryTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "entryId"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! EntryTableViewCell
        
        let row = indexPath.row
        let entry = entries[row]
        cell.title?.text = entry.title
        cell.subTitle?.text = split(entry.contentSnippet) {$0 == "\n"} [0]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry = entries[indexPath.row]
        UIApplication.sharedApplication().openURL(entry.link)
        entryTableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Add to Reading List" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
        
            let entry = self.entries[indexPath.row]

            let objectsToShare = [entry.title, entry.link]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        })
        
        var rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Star" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let entry = self.entries[indexPath.row]
            
            let identifier = "entryId"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! EntryTableViewCell
            cell.title?.textColor = UIColor.blueColor()
            
            self.entryTableView.editing = false
        })
        
        return [rateAction, shareAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

