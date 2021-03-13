//
//  ProfileViewController.swift
//  439FinalProject
//
//  Created by Kevin Ding on 3/11/21.
//

import UIKit
import Firebase
import PhoneNumberKit
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var phoneNumber: PhoneNumberTextField!
    let db = Firestore.firestore()
    let phoneNumberKit = PhoneNumberKit()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func modifyUsername(_ sender: UIButton) {
    }
    
    @IBAction func modifyICE(_ sender: UIButton) {
    }
    
    func getUserData() {
        if let user = Auth.auth().currentUser {
            db.collection("users").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                if let uid = document.data()["uid"] {
                                    if(uid as! String == user.uid) {
                                        self.UsernameTextField.text = document.data()["username"] as? String
                                        if (document.data()["phoneNumber"] != nil) {
                                            do {
                                                let number = try self.phoneNumberKit.parse(document.data()["phoneNumber"] as! String)
                                                self.phoneNumber.text = self.phoneNumberKit.format(number, toType: .national)
                                            }
                                            catch {
                                                print("Generic parser error")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
        }
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
