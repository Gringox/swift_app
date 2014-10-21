//
//  DetailsViewController.swift
//  test
//
//  Created by Pedro Luis Valdivieso on 10/11/14.
//  Copyright (c) 2014 ucv. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController, UpdateFormViewControllerProtocol {
  
  @IBOutlet weak var appCover: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  var app: App?
  
  // API controller that do HTTP requests
  var api : APIController?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.text = self.app?.name
    contentLabel.text = self.app?.description
    appCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.app!.imageURL)))
  }
  
  @IBAction func deleteButton(sender : AnyObject) {
    
    var deleteAlert = UIAlertController(title: "Delete \(self.app!.name)", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
    
    deleteAlert.addAction(UIAlertAction(title: "Yup", style: .Default, handler: { (action: UIAlertAction!) in
      
      let id = self.app!.id as Int
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      self.api!.makeDELETE("http://localhost:4567/apps/\(id)", id: id)
      self.navigationController!.popViewControllerAnimated(true)
      
    }))
    
    deleteAlert.addAction(UIAlertAction(title: "Nope", style: .Default, handler: { (action: UIAlertAction!) in
      //println("Handle Cancel Logic here")
    }))
    
    presentViewController(deleteAlert, animated: true, completion: nil)
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var updateFormViewController: UpdateFormViewController = segue.destinationViewController as UpdateFormViewController
    var selectedApp = self.app
    updateFormViewController.delegate = self
    updateFormViewController.app = selectedApp
    updateFormViewController.api = api
  }
  
  func updateFormDidFinish(newAppName: String, newAppDescription: String) {
    titleLabel.text = newAppName
    contentLabel.text = newAppDescription
  }
  
}