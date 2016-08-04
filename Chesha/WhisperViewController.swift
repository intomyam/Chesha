
//
//  WhisperViewController.swift
//  Chesha
//
//  Created by tomy on 2016/03/31.
//  Copyright © 2016年 Silva. All rights reserved.
//

import UIKit

class WhisperViewController: UIViewController {
  @IBOutlet weak var whisperTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
      //backView.userInteractionEnabled = true
      //backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "backViewTapped:"))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  @IBAction func backViewTap(sender: AnyObject) {
    self.view.endEditing(true)
  }
    
  @IBAction func whisperTap(sender: AnyObject) {
    CroudiaAPI.whisper({ data, response, error in
    }, status: whisperTextField.text!)
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
