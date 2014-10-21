//
//  Apps.swift
//  test
//
//  Created by Pedro Luis Valdivieso on 10/11/14.
//  Copyright (c) 2014 ucv. All rights reserved.
//

import Foundation

class App {
  
  var id: Int
  var name: String
  var description: String
  var imageURL: String
  
  init(id: Int, name: String, description: String, imageURL: String) {
    self.name = name
    self.description = description
    self.imageURL = imageURL
    self.id = id
  }
  
  class func appsWithJSON(allResults: NSArray) -> [App] {
    
    // Create an empty array of Albums to append to from this list
    var apps = [App]()
    
    // Store the results in our table data array
    if allResults.count>0 {
      
      // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
      for result in allResults {
        
        var id = result["id"] as Int
        var name = result["name"] as String
        var description = result["description"] as String
        var image = "http://localhost:4567/\(id%10).png" as String
        
        var newApp = App(id: id, name: name, description: description, imageURL: image)
        apps.append(newApp)
      }
    }
    return apps
  }
  
  class func deleteAppFromArray(apps: [App], id: String) -> [App] {
    
    var newApps = apps
    
    var counter = 0;
    for app in newApps {
      if id.toInt() == app.id {
        break
      }
      counter++
    }
    newApps.removeAtIndex(counter)
    
    return newApps
  }
  
}