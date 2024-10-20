//
//  OtpViewController.swift
//  Flash Chat iOS13
//
//  Created by Aavhan Chatse on 12/09/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class OtpViewController: UIViewController {
    var verificationID: String?

    @IBOutlet var otpTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func verifyOtpPressed(_ sender: UIButton) {
        if let verifyId = verificationID, let code = otpTextField.text {
            let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(
                withVerificationID: verifyId,
                verificationCode: code
            )

            Auth.auth().signIn(with: credential) { _, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.storeUserInDatabase()
//                    self.performSegue(withIdentifier: K.otpToChatSegue, sender: self)
                }
            }
        }
    }

    func storeUserInDatabase() {
        let user: User? = Auth.auth().currentUser
        let db = Firestore.firestore()

        do {
            try db.collection(K.FStore.usersCollectionName).document(user?.phoneNumber ?? "phoneNumber").setData([
                K.phoneNumber: user?.phoneNumber ?? "phoneNumber",
                K.uid: user?.uid ?? "uid",
            ])

            self.performSegue(withIdentifier: K.otpToUserListSegue, sender: self)
        } catch {
            print("Error adding document: \(error)")
        }
    }
}
