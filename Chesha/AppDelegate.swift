//
//  AppDelegate.swift
//  Chesha
//
//  Created by tomy on 2016/02/10.
//  Copyright © 2016年 Silva. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    let config = Realm.Configuration(
      schemaVersion: 2,
      migrationBlock: { migration, oldSchemaVersion in
        if (oldSchemaVersion < 1) {
        }
    })
    Realm.Configuration.defaultConfiguration = config
    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    let code = CroudiaAPI.getQueryStringParameter(url.absoluteString, param: "code")
    
    if code != nil {
      CroudiaAPI.getAccessToken(code!, completionHandler: { data, response, error in
        let json = JSON(data: data!)
    
        let account = Account()
        account.access_token = json["access_token"].string!
        account.refresh_token = json["refresh_token"].string!
        account.expired_at = NSDate(timeIntervalSinceNow: json["expires_in"].double!)
        
        print(json["access_token"].string!)
        print(json["refresh_token"].string!)
        
        let realm = try! Realm()
        try! realm.write {
          realm.deleteAll()
        }
        
        try! realm.write {
          realm.add(account)
        }
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(account.id, forKey: "nowAccount")
        ud.synchronize()
        
        CroudiaAPI.completeAccount(account)
        
        ud.setObject(account.id, forKey: "nowAccount")
        ud.synchronize()
      })
    }

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let nextVC = storyboard.instantiateViewControllerWithIdentifier("tab_bar")
    window?.rootViewController = nextVC
    
    return true
  }


}

