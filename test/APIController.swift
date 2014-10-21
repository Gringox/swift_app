//
//  APIController.swift
//  test
//
//  Created by Pedro Luis Valdivieso on 10/11/14.
//  Copyright (c) 2014 ucv. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
  func didReceiveAPIResults(results: NSArray)
}

class APIController {
  
  var delegate: APIControllerProtocol
  
  init(delegate: APIControllerProtocol) {
    self.delegate = delegate
  }
  
  func makeGET(urlPath: String) {
    let url: NSURL = NSURL(string: urlPath)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
      if(error != nil) {
        // If there is an error in the web request, print it to the console
        println("Error in the web request")
        println(error.localizedDescription)
      }
    
      var err: NSError?
      let results = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSArray
    
      if(err != nil) {
        // If there is an error parsing JSON, print it to the console
        println("Error parsing JSON")
        println("JSON Error \(err!.localizedDescription)")
      }
      
      self.delegate.didReceiveAPIResults(results)
    
    })
    
    task.resume()
  }
  
  func makeDELETE(urlPath: String, id: Int){
    let request = NSMutableURLRequest(URL: NSURL(string: urlPath))
    let session = NSURLSession.sharedSession()
    
    request.HTTPMethod = "DELETE"
    
    let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      //println("Response: \(response)")
      //let strData = NSString(data: data, encoding: NSUTF8StringEncoding)
      //println("Body: \(strData)")
      
      var responseArray = [String]()
      responseArray.append("DELETE")
      responseArray.append(String(id))
      self.delegate.didReceiveAPIResults(responseArray)
      
    })
    
    task.resume()
  }
  
  func makePUT(urlPath: String, params : Dictionary<String, String>) {
    let request = NSMutableURLRequest(URL: NSURL(string: urlPath))
    let session = NSURLSession.sharedSession()
    
    request.HTTPMethod = "PUT"
    
    var err: NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    if (err != nil) {
      println("Problem casting Dictionary to JSON")
    }else{
    
      let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        //println("Response: \(response)")
        //let strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        //println("Body: \(strData)")
        var err: NSError?
        let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
      
        self.makeGET("http://localhost:4567/apps")
      })
      
      task.resume()
      
    }

  }
  
  func makePOST (urlPath: String, params : Dictionary<String, String>) {
    let request = NSMutableURLRequest(URL: NSURL(string: urlPath))
    let session = NSURLSession.sharedSession()
    
    request.HTTPMethod = "POST"
    
    var err: NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    if (err != nil) {
      println("Problem casting Dictionary to JSON")
    }else{
      
      let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        //println("Response: \(response)")
        //let strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        //println("Body: \(strData)")
        var err: NSError?
        let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        
        self.makeGET("http://localhost:4567/apps")
      })
      
      task.resume()
      
    }
  }
  
}