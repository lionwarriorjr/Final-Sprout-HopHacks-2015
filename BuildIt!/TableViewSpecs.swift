//
//  TableViewSpecs.swift
//  BuildIt!
//
//  Created by Srihari Mohan on 7/25/15.
//  Copyright (c) 2015 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit

class TableViewSpecs: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pinsArray = pinObject.localPinData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        showProfile()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .Plain, target: self, action: "showProfile")
    }
    
    func showProfile() {
        self.performSegueWithIdentifier("showProfileScreen", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pinsArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellForProject") as! UITableViewCell
        let currentPin = self.pinsArray[indexPath.row];
        cell.imageView?.image = currentPin.baseImage
        cell.textLabel?.text = currentPin.title
        cell.detailTextLabel?.text = currentPin.region
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
//        detailVC.this_pin_object = self.pinsArray[indexPath.row]
//        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
