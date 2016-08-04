//
//  UserTableViewController.swift
//  Chesha
//
//  Created by tomy on 2016/04/12.
//  Copyright © 2016年 Silva. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserTableViewController: UITableViewController {
  var croudia_id: Int?
  private var tweets: JSON = nil

    override func viewDidLoad() {
      if croudia_id == nil {
        croudia_id = Application.account!.croudia_id
        print(Application.account!.croudia_id)
        print(Application.account!)
      }
      super.viewDidLoad()

      CroudiaAPI.getUserTimeline({ data, response, error in
        if (response as! NSHTTPURLResponse).statusCode == 200 {
          self.tweets = JSON(data: data!)
          self.tableView.reloadData()
        }
      }, croudia_id: croudia_id!)
      
      // self.clearsSelectionOnViewWillAppear = false
      
      self.refreshControl = UIRefreshControl()
      self.refreshControl!.attributedTitle = NSAttributedString(string: "引っ張って更新")
      self.refreshControl!.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
      self.tableView.addSubview(refreshControl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("tweet", forIndexPath: indexPath)
    cell.textLabel!.text = "\(tweets[indexPath.row]["text"])"
    cell.detailTextLabel!.text = tweets[indexPath.row]["user"]["name"].string!
    cell.imageView!.imageFromUrl(tweets[indexPath.row]["user"]["profile_image_url_https"].string!)
    
    return cell
  }
  
  func refresh()
  {
    CroudiaAPI.getUserTimeline({ data, response, error in
      if (response as! NSHTTPURLResponse).statusCode == 200 {
        self.tweets = JSON(data: data!)
        self.tableView.reloadData()
      }

      self.refreshControl!.endRefreshing()
    }, croudia_id: croudia_id!)
  }
}
