//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!

    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print(authResult)
                    if let authData = authResult {
//                        self.performSegue(withIdentifier: K.registerSegue, sender: self)
                        self.storeUserInDatabase()
                    }
                }
            }
        }
    }

    func storeUserInDatabase() {
        let user: User? = Auth.auth().currentUser
        let db = Firestore.firestore()

        do {
            try db.collection(K.FStore.usersCollectionName).document(user?.email ?? "email").setData([
                K.email: user?.email ?? "email",
                K.uid: user?.uid ?? "uid",
            ])

            self.performSegue(withIdentifier: K.registerSegue, sender: self)
        } catch {
            print("Error adding document: \(error)")
        }
    }
}
