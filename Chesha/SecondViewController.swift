//
//  SecondViewController.swift
//  Chesha
//
//  Created by tomy on 2016/02/10.
//  Copyright © 2016年 Silva. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
  @IBOutlet weak var auth: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
  @IBAction func authTouch(sender: AnyObject) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let nextVC = storyboard.instantiateViewControllerWithIdentifier("authView")
    self.presentViewController(nextVC, animated: false, completion: nil)
  }
}

