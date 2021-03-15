//
//  CreateHikeViewController.swift
//  439FinalProject
//
//  Created by Andrew Wu on 3/13/21.
//

import UIKit
import Firebase

class CreateHikeViewController : UIViewController {
    @IBOutlet weak var detailsBox: UITextView!
    
    //@IBOutlet weak var miscDetails: UITextField!
    override func viewDidLoad() {
        detailsBox.layer.borderWidth = 1.0
        detailsBox.layer.borderColor = UIColor.gray.cgColor
    }
}
