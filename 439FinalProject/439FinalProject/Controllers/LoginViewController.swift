//
//  LoginViewController.swift
//  439FinalProject
//
//  Created by Kevin Ding on 2/24/21.
//

import UIKit
import FirebaseDatabase
 
class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let ref = Database.database().reference()
        //ref.child("id/username").setValue("toirdak")
        ref.childByAutoId().setValue(["username": "Tori", "password": "Summer@1"])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
