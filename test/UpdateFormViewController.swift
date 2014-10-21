//
//  UpdateFormViewController.swift
//  test
//
//  Created by Pedro Luis Valdivieso on 10/12/14.
//  Copyright (c) 2014 ucv. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateFormViewControllerProtocol {
  func updateFormDidFinish(newAppName: String, newAppDescription: String)
}

class UpdateFormViewController : UIViewController {
  
  var delegate:UpdateFormViewControllerProtocol? = nil

  @IBOutlet weak var newName: UITextField!
  @IBOutlet weak var newDescription: UITextField!
  
  var app: App?
  
  // API controller that do HTTP requests
  var api : APIController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func okButton(sender : AnyObject) {
    
    let id = self.app!.id as Int
    let newAppName = newName.text as String
    let newAppDescription = newDescription.text as String
    
    if (newAppName != "" && newAppDescription != "") {
    
      var params : [String: String] = ["name":newAppName, "description":newAppDescription]
    
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      self.api!.makePUT("http://localhost:4567/apps/\(id)", params: params)
      
      self.delegate!.updateFormDidFinish(newAppName, newAppDescription: newAppDescription)
      
      self.navigationController!.popViewControllerAnimated(true)
    }
  }
  
}