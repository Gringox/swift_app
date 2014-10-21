//
//  ViewController.swift
//  test
//
//  Created by Pedro Luis Valdivieso on 10/9/14.
//  Copyright (c) 2014 ucv. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
  
  // The tableview at main.storyboard
  @IBOutlet var appsTableView : UITableView?
  
  // Table data goes here
  //var albums = [Album]()
  var apps = [App]()
  
  // API controller that do HTTP requests
  var api : APIController?
  
  // Cell identifier
  let kCellIdentifier: String = "SearchResultCell"
  
  // Image caching
  var imageCache = [String : UIImage]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    api = APIController(delegate: self)
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    api!.makeGET("http://localhost:4567/apps")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (sender?.tag != 2) {
      var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
      var appIndex = appsTableView!.indexPathForSelectedRow()!.row
      var selectedApp = self.apps[appIndex]
      detailsViewController.app = selectedApp
      detailsViewController.api = api
    }else{
      var newAppFormViewController: NewAppFormViewController = segue.destinationViewController as NewAppFormViewController
      newAppFormViewController.api = api
    }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
    //return albums.count
    return apps.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
    
    let app = self.apps[indexPath.row]
    cell.textLabel?.text = app.name
    cell.imageView?.image = UIImage(named: "Blank52")
    
    cell.detailTextLabel?.text = app.description
    
    let urlString = app.imageURL
    
    var image = self.imageCache[urlString]
    
    if( image == nil ) {
      // If the image does not exist, we need to download it
      var imgURL: NSURL = NSURL(string: urlString)
      
      // Download an NSData representation of the image at the URL
      let request: NSURLRequest = NSURLRequest(URL: imgURL)
      NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
        if error == nil {
          image = UIImage(data: data)
          
          // Store the image in to our cache
          self.imageCache[urlString] = image
          dispatch_async(dispatch_get_main_queue(), {
            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
              cellToUpdate.imageView?.image = image
            }
          })
        }
        else {
          println("Error: \(error.localizedDescription)")
        }
      })
      
    }
    else {
      dispatch_async(dispatch_get_main_queue(), {
        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
          cellToUpdate.imageView?.image = image
        }
      })
    }
    
    return cell
  }
  
  func didReceiveAPIResults(results: NSArray) {
    dispatch_async(dispatch_get_main_queue(), {
      if let method = results[0] as? String {
        if (method == "DELETE") {
          if let id = results[1] as? String {
            self.apps = App.deleteAppFromArray(self.apps, id: id)
          }
        }
      } else {
        self.apps = App.appsWithJSON(results)
      }
      self.appsTableView!.reloadData()
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    })
  }
  
}

