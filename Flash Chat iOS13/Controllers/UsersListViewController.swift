//
//  UsersListViewController.swift
//  Flash Chat iOS13
//
//  Created by Aavhan Chatse on 20/09/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class UsersListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    let db = Firestore.firestore()
    let firebaseAuth = Auth.auth()

    var users: [UserModel] = []

    var sUser: UserModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.hidesBackButton = true
        title = K.appName

        loadUsers()
    }

    func loadUsers() {
        do {
            let currentUser = firebaseAuth.currentUser

            db.collection(K.FStore.usersCollectionName).addSnapshotListener { snapshot, error in
                self.users = []

                if let e = error {
                    print("Error getting documents: \(e)")
                } else {
                    if let snapshotDocuments = snapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()

                            let phoneNumber: String? = data[K.phoneNumber] as? String
                            let email: String? = data[K.email] as? String

                            if phoneNumber != currentUser?.phoneNumber || email != currentUser?.email {
                                let uid: String? = data[K.uid] as? String

                                let user = UserModel(phoneNumber: phoneNumber, email: email, uid: uid!)

                                self.users.append(user)

                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }

//            let snapshot = try await db.collection(K.users).getDocuments()
//            for document in snapshot.documents {
//                print("\(document.documentID) => \(document.data())")
//            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }

    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)

        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension UsersListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.userCellIdentifier, for: indexPath)

        cell.textLabel?.text = users[indexPath.row].phoneNumber != nil ? users[indexPath.row].phoneNumber : users[indexPath.row].email != nil ? users[indexPath.row].email : users[indexPath.row].uid

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        sUser = selectedUser

        performSegue(withIdentifier: K.chatSegue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.chatSegue {
            let destination = segue.destination as! ChatViewController
            destination.selectedUser = sUser
        }
    }
}
