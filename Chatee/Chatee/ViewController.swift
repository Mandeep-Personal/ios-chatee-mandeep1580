//
//  ViewController.swift
//  Chatee
//
//  Created by Mandeep Dhillon on 10/02/21.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let dbRef: DatabaseReference = Database.database().reference()
    dbRef.setValue("Hello there")
    
    // Do any additional setup after loading the view.
  }


}

