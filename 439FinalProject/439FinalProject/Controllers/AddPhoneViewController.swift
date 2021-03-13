//
//  AddPhoneViewController.swift
//  439FinalProject
//
//  Created by Kevin Ding on 3/12/21.
//

import UIKit
import PhoneNumberKit
import Firebase
class AddPhoneViewController: UIViewController {

    @IBOutlet weak var phoneNumber: PhoneNumberTextField!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addPhoneNumber(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        if let user = user {
            db.collection(Constants.FStoreUser.collectionName).document(user.uid).setData([
                Constants.FStoreUser.phoneNumber: phoneNumber.text!
            ], merge: true) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                }
            }
        }
        
    }
    
   
}
