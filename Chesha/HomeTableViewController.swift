//
//  HomeTableViewController.swift
//  Chesha
//
//  Created by tomy on 2016/02/15.
//  Copyright © 2016年 Silva. All rights reserved.
//

import UIKit
import SwiftyJSON

extension UIImageView {
  public func imageFromUrl(urlString: String) {
    if let url = NSURL(string: urlString) {
      let request = NSURLRequest(URL: url)
      let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
      let session = NSURLSession(configuration: configuration, delegate:nil, delegateQueue:NSOperationQueue.mainQueue())
      let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        if let imageData = data as NSData? {
          self.image = UIImage(data: imageData)
        }
      })
      
      task.resume()
      
      /*
      NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
        (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
        if let imageData = data as NSData? {
          self.image = UIImage(data: imageData)
        }
      }
      */
    }
  }
}

class HomeTableViewController: UITableViewController {
  private var tweets: JSON = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    self.refreshControl = UIRefreshControl()
    self.refreshControl!.attributedTitle = NSAttributedString(string: "引っ張って更新")
    self.refreshControl!.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(refreshControl!)
    
    loadTimeline()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  /*
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 0
  }
*/
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return tweets.count
  }
  

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("tweet", forIndexPath: indexPath)
    cell.textLabel!.text = "\(tweets[indexPath.row]["text"])"
    cell.detailTextLabel!.text = tweets[indexPath.row]["user"]["name"].string!
    cell.imageView!.imageFromUrl(tweets[indexPath.row]["user"]["profile_image_url_https"].string!)
    
    
    return cell
  }

  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the specified item to be editable.
  return true
  }
  */
  
  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  if editingStyle == .Delete {
  // Delete the row from the data source
  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  } else if editingStyle == .Insert {
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
  }
  */
  
  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
  
  }
  */
  
  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the item to be re-orderable.
  return true
  }
  */
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
  func loadTimeline(){
    
    print(Application.account!.refresh_token)
    print(Application.account!.expired_at)
    
    CroudiaAPI.getHomeTimeline({ data, response, error in
      self.tweets = JSON(data: data!)
      //print(self.tweets)
      self.tableView.reloadData()
    })
  }
  
  @IBAction func refreshTouch(sender: AnyObject) {
    CroudiaAPI.refleshAccessToken({refleshData, refleshResponse, refleshError in
      self.refresh()
    })
  }
  
  func refresh()
  {
    CroudiaAPI.getHomeTimeline({ data, response, error in
      self.tweets = JSON(data: data!)
      self.tableView.reloadData()
      self.refreshControl!.endRefreshing()
    })
  }
}
