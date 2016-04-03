//
//  Account.swift
//  Chesha
//
//  Created by tomy on 2016/02/11.
//  Copyright © 2016年 Silva. All rights reserved.
//

import RealmSwift

class Account: Object {
  dynamic var id = 0
  dynamic var croudia_id = 0
  dynamic var name = ""
  dynamic var screen_name = ""
  dynamic var profile_image_url_https = ""
  dynamic var cover_image_url_https = ""
  
  dynamic var access_token = ""
  dynamic var refresh_token = ""
  dynamic var expired_at: NSDate = NSDate()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  func updateAccessToken(access_token: String, refresh_token: String, expired_at: NSDate) {
    let realm = try! Realm()
    try! realm.write {
      self.access_token = access_token
      self.refresh_token = refresh_token
      self.expired_at = expired_at
    }
  }
}
