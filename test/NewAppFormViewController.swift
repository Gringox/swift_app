//
//  NewAppFormViewController.swift
//  test
//
//  Created by Pedro Luis Valdivieso on 10/15/14.
//  Copyright (c) 2014 ucv. All rights reserved.
//

import Foundation
import UIKit

class NewAppFormViewController: UIViewController {

  @IBOutlet weak var nameTextfield: UITextField!
  @IBOutlet weak var descriptionTextField: UITextField!
  
  // API controller that do HTTP requests
  var api : APIController?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func deleteButton(sender : AnyObject) {
    let newAppName = nameTextfield.text as String
    let newAppDescription = descriptionTextField.text as String
    
    if (newAppName != "" && newAppDescription != "") {
      
      var params : [String: String] = ["name":newAppName, "description":newAppDescription]
      
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      
      self.api!.makePOST("http://localhost:4567/apps", params: params)
      
      self.navigationController!.popViewControllerAnimated(true)
    }
  }
  
}