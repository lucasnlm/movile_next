//
//  EpisodesCollectionViewController.swift
//  MovileNext
//
//  Created by User on 14/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit
import TraktModels

let reuseIdentifier = "Cell"
let notKey = "com.movile.up.favorites"

class ShowCollectionViewController: UIViewController,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var navegationBar: UINavigationBar!
    
    @IBOutlet weak var segmentedControlView: UISegmentedControl!

    @IBOutlet weak var pageController: UIPageControl!
    
    let trakt = TraktHTTPClient()
    
    var shows : [Show] = []
    
    var totalPages = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.navigationItem.title = "Shows"
        
        collectionView.delegate = self
        collectionView.dataSource = self
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onListenToNotification", name: notKey, object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(notKey, object: self)
    }
    
    @IBAction func onChangePage(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(notKey, object: self)
    }
    
    func onListenToNotification() {
        let selectedIndex = self.segmentedControlView.selectedSegmentIndex
        
        if selectedIndex == 0 {
            refreshList(false, clearAll: true)
        } else {
            refreshList(true, clearAll: true)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == Segue.shows_to_details {
            if let cell = sender as? UICollectionViewCell,
                indexPath = collectionView.indexPathForCell(cell) {
                    let vc = segue.destinationViewController as! ShowDetailsController
                    vc.show = shows[indexPath.row]
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            let selectedIndex = self.segmentedControlView.selectedSegmentIndex
            
            if selectedIndex == 0 {
                refreshList(false, clearAll: false)
            } else {
                refreshList(true, clearAll: false)
            }
           // self.collectionView.reloadData()
        }
    }
    
    func refreshList(showOnlyFav: Bool, clearAll: Bool) {
        if clearAll {
            self.shows.removeAll(keepCapacity: true)
            totalPages = 1
        } else {
            totalPages++
        }
        
        trakt.getPopularShows(totalPages) { result in
            let showResult = result.value!
            for show in showResult {
                if(!showOnlyFav || FavoritesManager.isFavorite(show.identifiers.trakt)) {
                    self.shows.append(show)
                }
            }
            
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func onSeguimentionBarChanged(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(notKey, object: self)
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hideBottomHairline()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = Reusable.ShowCell.identifier!
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! SerieCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        
        let show = shows[indexPath.item]
        cell.titleView?.text = show.title
        cell.loadShow(show)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.35
        pulseAnimation.fromValue = 0.7
        pulseAnimation.toValue = 1.0
        pulseAnimation.autoreverses = false
        pulseAnimation.repeatCount = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        cell.layer.addAnimation(pulseAnimation, forKey: nil)
    }

    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemSize = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
        let maxPerRow = floor(collectionView.bounds.width / itemSize)
        let userSpace = itemSize * maxPerRow
        let additionalSpace = flowLayout.minimumInteritemSpacing * maxPerRow
        
        let sideSpace = floor(((collectionView.bounds.width - userSpace) + additionalSpace) / (maxPerRow + 1))
        return UIEdgeInsetsMake(flowLayout.sectionInset.top, sideSpace, flowLayout.sectionInset.bottom, sideSpace)
    }
}
