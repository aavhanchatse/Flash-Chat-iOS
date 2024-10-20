//
//  PhoneNumberViewController.swift
//  Flash Chat iOS13
//
//  Created by Aavhan Chatse on 12/09/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import FirebaseAuth
import UIKit

class PhoneNumberViewController: UIViewController {
    @IBOutlet var phoneNumberTextField: UITextField!

    var verifyId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sendOtpPressed(_ sender: UIButton) {
        if let phoneNumber = phoneNumberTextField.text {
//            print("+91\(phoneNumber)")

            PhoneAuthProvider.provider()
                .verifyPhoneNumber("+91\(phoneNumber)", uiDelegate: nil) { verificationID, error in
                    if let error = error {
//                        self.showMessagePrompt(error.localizedDescription)

                        print(error)

                        print(error.localizedDescription)

                        return
                    } else {
//                        print("verificationID: \(verificationID)")

                        self.verifyId = verificationID
                        // Sign in using the verificationID and the code sent to the user
                        self.performSegue(withIdentifier: K.sendOtpSegue, sender: self)
                    }
                }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.sendOtpSegue {
            let destination = segue.destination as! OtpViewController
            destination.verificationID = verifyId
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
