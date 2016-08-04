//
//  CroudiaAPI.swift
//  Chesha
//
//  Created by tomy on 2016/02/12.
//  Copyright © 2016年 Silva. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class CroudiaAPI {
  static let clientID = "1e08645c63f0d5fb1d5df667649cf7f0dcfb633ef6462fad0bf85f0f290166b9"
  static let clientSecret = "2de9902f1fbabfcbe8a1b95fd6f18f538257753fb6b5d37a8fe419203fd5f549"
  
  static func getQueryStringParameter(url: String, param: String) -> String? {
    let url = NSURLComponents(string: url)!
    
    return
      (url.queryItems! as [NSURLQueryItem]).filter({ (item) in item.name == param }).first?.value!
  }
  
  static func getAccessToken(code: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request: Request = Request()

    let urlComponents = NSURLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.croudia.com"
    urlComponents.path = "/oauth/token"
    let grantTypeQuery    = NSURLQueryItem(name: "grant_type", value: "authorization_code")
    let clientIDQuery     = NSURLQueryItem(name: "client_id", value: clientID)
    let clientSecretQuery = NSURLQueryItem(name: "client_secret", value: clientSecret)
    let codeQuery         = NSURLQueryItem(name: "code", value: code)
    urlComponents.queryItems = [grantTypeQuery, clientIDQuery, clientSecretQuery, codeQuery]
    
    let body: NSMutableDictionary = NSMutableDictionary()
    
    request.post(urlComponents.URL!, body: body, completionHandler: completionHandler)
  }
  
  static func refleshAccessToken(completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request: Request = Request()
    
    let urlComponents = NSURLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.croudia.com"
    urlComponents.path = "/oauth/token"
    
    let body: NSMutableDictionary = NSMutableDictionary()
    body.setValue("refresh_token", forKey: "grant_type")
    body.setValue(clientID, forKey: "client_id")
    body.setValue(clientSecret, forKey: "client_secret")
    body.setValue(Application.account!.refresh_token, forKey: "refresh_token")
    
    request.post(urlComponents.URL!, body: body, completionHandler: { data, response, error in
      // let out: NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
      // print(out)
      
      let code = (response as! NSHTTPURLResponse).statusCode
      if  code == 200 {
        let json = JSON(data: data!)
        Application.account!.updateAccessToken(json["access_token"].string!,
          refresh_token: json["refresh_token"].string!,
          expired_at: NSDate(timeIntervalSinceNow: json["expires_in"].double!))
      }
      
      completionHandler(data, response, error)
    })
  }
  
  static func completeAccount(account: Account){
    CroudiaAPI.getVerifyCredentials({ data, response, error in
      let json = JSON(data: data!)
      
      let realm = try! Realm()
      try! realm.write {
        account.croudia_id = json["id"].int!
        account.name = json["name"].string!
        account.screen_name = json["screen_name"].string!
        account.profile_image_url_https = json["profile_image_url_https"].string!
        account.cover_image_url_https = json["cover_image_url_https"].string!
      }
    })
  }
  
  static func getVerifyCredentials(completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request: Request = Request()
    
    let urlComponents = NSURLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.croudia.com"
    urlComponents.path = "/account/verify_credentials.json"
    
    request.get(urlComponents.URL!, completionHandler: completionHandler)
  }
  

  static func getHomeTimeline(completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request: Request = Request()
    
    let urlComponents = NSURLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.croudia.com"
    urlComponents.path = "/2/statuses/home_timeline.json"
    
    request.get(urlComponents.URL!, completionHandler: { data, response, error in
      let code = (response as! NSHTTPURLResponse).statusCode
      if  code == 401 {
        refleshAccessToken({refleshData, refleshResponse, refleshError in
        })
      }
      
      completionHandler(data, response, error)
    })
  }
  
  static func getUserTimeline(completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void,
    croudia_id: Int = 0, screen_name: String = "") {
    let request: Request = Request()
    
    let urlComponents = NSURLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.croudia.com"
    urlComponents.path = "/2/statuses/user_timeline.json"
    
    let croudiaIdQuery = NSURLQueryItem(name: "user_id", value: String(croudia_id))
    let screenNameQuery = NSURLQueryItem(name: "screen_name", value: screen_name)
    urlComponents.queryItems = [croudiaIdQuery, screenNameQuery]
    
    request.get(urlComponents.URL!, completionHandler: { data, response, error in
      print(response)
      let code = (response as! NSHTTPURLResponse).statusCode
      if  code == 401 {
        refleshAccessToken({refleshData, refleshResponse, refleshError in
        })
      }
      
      completionHandler(data, response, error)
    })
  }
  
  
  static func whisper(completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void, status: String) {
    let request: Request = Request()
    
    let urlComponents = NSURLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.croudia.com"
    urlComponents.path = "/2/statuses/update.json"
    
    let body: NSMutableDictionary = NSMutableDictionary()
    body.setValue(status, forKey: "status")
    
    request.postWithToken(urlComponents.URL!, body: body, completionHandler: { data, response, error in
      let out: NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
      print(out)
      
      completionHandler(data, response, error)
    })
  }
}