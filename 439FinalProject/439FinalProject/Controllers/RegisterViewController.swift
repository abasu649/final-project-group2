//
//  RegisterViewController.swift
//  439FinalProject
//
//  Created by Kevin Ding on 2/24/21.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerPressed(_ sender: UIButton) {
        guard let username = usernameText.text, !username.isEmpty else {
            displayAlertMessage (msg:"Forget to fill your user name")
               return
          }
        guard let password = passwordText.text, !password.isEmpty else {
            displayAlertMessage (msg:"Forget to fill your password")
               return
          }
        guard let email = emailText.text, !email.isEmpty else {
            displayAlertMessage (msg:"Forget to fill your eamil")
               return
          }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                if let errCode = AuthErrorCode(rawValue: e._code) {
                    switch errCode {
                        case .emailAlreadyInUse:
                            self.displayAlertMessage (msg:"This email aleady exist")
                        case .invalidEmail:
                            self.displayAlertMessage (msg:"Please use valid email")
                        case .weakPassword:
                            self.displayAlertMessage (msg:"Please use stronger password")
                        default:
                            self.displayAlertMessage (msg:"Whoops, please try again")
                    }
                }
               return
            } else {
                self.storeToFStore (username: username)
                //Navigate to the ChatViewController
                self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
            }
        }
    
    }
    func storeToFStore (username:String) {
        let user = Auth.auth().currentUser
        if let user = user {
            var ref: DocumentReference? = nil
            ref = db.collection(Constants.FStoreUser.collectionName).addDocument(data: [
                Constants.FStoreUser.uid: user.uid,
                Constants.FStoreUser.username: username,
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
    func displayAlertMessage(msg:String){

        let myAlert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
     }
    

}
