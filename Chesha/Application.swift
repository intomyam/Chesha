//
//  Application.swift
//  Chesha
//
//  Created by tomy on 2016/02/14.
//  Copyright © 2016年 Silva. All rights reserved.
//

import Foundation
import RealmSwift

class Application {
  static var account: Account? {
    let ud = NSUserDefaults.standardUserDefaults()
    let accountId = ud.objectForKey("nowAccount")
    
    if accountId == nil {
      return nil
    } else {
      let realm = try! Realm()
      return realm.objects(Account)[accountId as! Int]
    }
  }
}