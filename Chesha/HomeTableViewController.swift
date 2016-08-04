//
//  HomeTableViewController.swift
//  Chesha
//
//  Created by tomy on 2016/02/15.
//  Copyright © 2016年 Silva. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

extension UIImageView {
  public func imageFromUrl(urlString: String) {
    
    /*
    let url = NSURL(string: urlString);
    let imageData :NSData = try! NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe)
    
    self.image = UIImage(data:imageData);
    

    return
    */
    
    
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
  
  var selected_croudia_id: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    CroudiaAPI.getHomeTimeline({ data, response, error in
      if (response as! NSHTTPURLResponse).statusCode == 200 {
        self.tweets = JSON(data: data!)
        print("get")
        self.tableView.reloadData()
      }
    })
    
    // self.clearsSelectionOnViewWillAppear = false
    
    self.refreshControl = UIRefreshControl()
    self.refreshControl!.attributedTitle = NSAttributedString(string: "引っ張って更新")
    self.refreshControl!.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(refreshControl!)
  }
  
  override func viewWillAppear(animated: Bool) {
    //loadTimeline()
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  
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
  
  override func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
    selected_croudia_id = tweets[indexPath.row]["user"]["id"].int

    if selected_croudia_id != nil {
      performSegueWithIdentifier("toUserTableViewController",sender: nil)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "toUserTableViewController") {
      let userTableViewController = segue.destinationViewController as! UserTableViewController
      userTableViewController.croudia_id = selected_croudia_id
    }
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
    CroudiaAPI.getHomeTimeline({ data, response, error in
      self.tweets = JSON(data: data!)
      //print(self.tweets)
      print("get")
      self.tableView.reloadData()
    })
  }

  
  func refresh()
  {
    CroudiaAPI.getHomeTimeline({ data, response, error in
      if (response as! NSHTTPURLResponse).statusCode == 200 {
        self.tweets = JSON(data: data!)
        self.tableView.reloadData()
      }
      self.refreshControl!.endRefreshing()
    })
  }
}
