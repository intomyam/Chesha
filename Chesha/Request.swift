//
//  Request.swift
//  Chesha
//
//  Created by tomy on 2016/02/12.
//  Copyright © 2016年 Silva. All rights reserved.
//
// http://qiita.com/Shirade/items/80d2ed2114d7352a7551

import Foundation

extension NSDictionary{
  func paramsString() -> String {
    let pairs = NSMutableArray()
    for (key,value) in self as! [String:AnyObject]  {
      if value is NSDictionary {
        for (dictKey,dictValue) in value as! [String:String]{
          pairs.addObject("\(key)[\(dictKey)]=\(escapString(dictValue))")
        }
      }else if value is NSArray {
        for arrayValue in value as! [String] {
          pairs.addObject("\(key)[]=\(escapString(arrayValue))")
        }
      }else{
        pairs.addObject("\(key)=\(escapString(value as! NSString as String))")
      }
    }
    let queryString = pairs.componentsJoinedByString("&")
    return "?\(queryString)"
  }
  
  func escapString(value:String!) -> String {
    // エンコードしたくない文字セットを作成
    let customAllowedSet =  NSCharacterSet(charactersInString:"!*'()@&=+$,/?%#[];:").invertedSet
    // 指定された文字セット以外の文字を全てパーセントエンコーディング
    return value.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
  }
}

class Request {
  let session: NSURLSession = NSURLSession.sharedSession()
  
  // GET METHOD
  func get(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    
    request.HTTPMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer " + Application.account!.access_token, forHTTPHeaderField: "Authorization")
    session.dataTaskWithRequest(request, completionHandler: { data, response, error in
      //let out: NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
      //print(out)

      completionHandler(data, response, error)
    }).resume()
  }
  
  // POST METHOD
  func post(url: NSURL, body: NSMutableDictionary, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    do {
      request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.init(rawValue: 2))
    } catch {
      // Error Handling
      print("NSJSONSerialization Error")
      return
    }

    session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
  }
  
  // POST METHOD
  func postWithToken(url: NSURL, body: NSMutableDictionary, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    
    request.HTTPMethod = "POST"
    request.addValue("Bearer " + Application.account!.access_token, forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    do {
      request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.init(rawValue: 2))
    } catch {
      // Error Handling
      print("NSJSONSerialization Error")
      return
    }
    
    session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
  }
  
  // PUT METHOD
  func put(url: NSURL, body: NSMutableDictionary, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    
    request.HTTPMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    do {
      request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.init(rawValue: 2))
    } catch {
      // Error Handling
      print("NSJSONSerialization Error")
      return
    }
    session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
  }
  
  // DELETE METHOD
  func delete(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    
    request.HTTPMethod = "DELETE"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
  }
}
